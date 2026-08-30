---
title: how to automate your ml project with gitlab and dataiku
date: '2023-09-05 18:30:00+00:00'
---

![Automation](/assets/images/automation.webp){: width="1600" height="1067"}

## Introduction

Continuous Integration and Delivery enable teams to automate all necessary steps to build, test, and deploy code to the production environment. The result is a faster development cycle and a lower error rate. For a data science team, having a CI/CD pipeline is crucial to delivering machine learning models to production in a timely and high-quality manner.

Recently, we began investing in and building our data science products using Dataiku and GitLab. This project presented its own set of complexities, and CI/CD was one of them. With many stakeholders with diverse experiences and roles, we had to be very flexible while keeping things simple and automating a large part of our workflow.

In this blog post, I will share the step-by-step approach we took and the challenges we faced in building the CI/CD pipeline using GitLab and deploying the project/models in Dataiku.

## Introduction to Dataiku

Large companies use various new tools and platforms to build products efficiently. Typically, they are not concerned about the pricing of these platforms. One of the emerging platforms is Dataiku, which is similar to AWS SageMaker in terms of machine learning development.

With Dataiku, you can explore, visualize, and wrangle data, build machine learning models, and deploy them as real-time APIs or batch predictions.

### Flow

You can build and visualize your data science projects using a flow. The flow contains different recipes, such as split, sort, or Python code recipes, and visualizes datasets and ML models.

An example of a visual recipe is joining two datasets using the right outer join. To create a join recipe, use the two datasets as inputs and obtain the joined output dataset. To do this, select the "build" option in the right sidebar.

We had a very complex flow with hundreds of visual and code recipes following a complex set of rules.

*Photo by Dataiku*

### Metrics

In production, data is frequently ingested, perhaps on a daily or hourly basis. If there are quality issues with the data that go undetected, and pipelines continue to feed it to the models in production, this can negatively impact the user experience and cost you money. This is why Dataiku provides metrics and checks to monitor data quality and the data model.

Metrics are built on datasets to ensure that they fall within the thresholds you've set. For example, you can monitor the number of missing values in a column or the size of the model.

We had metrics in place to monitor running sales, revenue, and model size.

*Photo by Dataiku*

### Checks

Once we have defined our metrics, we can add checks to validate the data for any concerns. These checks can be used to provide necessary thresholds for our metrics. For example, we can check that the size of the model does not exceed 3.5 GB. If the model size exceeds this threshold, we can display a warning or error message, depending on our configuration.

We had checks in place to monitor data drift, data validity, and statistics.

*Photo by Dataiku*

### Scenarios

We can automate the workflow by using scenarios to compute metrics, run checks, train models, generate predictions, and so on. In our project, we have a `TEST_SCENARIO` that builds datasets, computes metrics, runs checks, generates predictions, evaluates scores, and plots visualizations. This scenario is always executed as part of our integration tests and is triggered by our CI/CD pipeline.

*Photo by Dataiku*

### Design Node

Dataiku servers are called nodes. The design node is where data science teams build workflows and models. This is the development environment where teams can experiment and build projects. The automation node is the production environment. We can have different infrastructures in the same node as well.

Once we complete building our workflow, we need to package the project into a bundle. A bundle is a skeleton of the project that contains the metadata of datasets, notebooks, scenarios, and other artifacts.

### Project Deployer

The project deployer is a middleware between the design node and the automation node. It is responsible for deploying bundles to the automation node. We can see the currently active bundles in the automation node through the project deployer.

As a rule of thumb, software engineers should not directly interact with the automation node, but only through the project deployer. This is because the project deployer provides a layer of abstraction that makes it easier to manage and deploy projects.

For batch processing, we use the automation node. This is because the automation node has the resources and infrastructure to run large-scale batch jobs.

For real-time scoring, we use the API node. This is because the API node is designed to handle high-volume, low-latency requests.

*Photo by Dataiku*

## GitLab CI/CD

Let's use GitLab CI/CD to create pipelines for our project. We've been using the enterprise version of GitLab, with our own set of managed shared runners. However, you can use GitLab's CI/CD feature with a free plan, but you will have to create the runners yourself.

To write CI/CD configuration, you need a `.gitlab-ci.yaml` file in the root of your repository. This file contains all the information about the scripts to run, the stages in the workflow, how to trigger the pipeline, and so on. You can use GitLab's pipeline editor feature to write, edit, and validate the pipeline.

### Introduction to CI/CD Pipelines

There are many ways to configure a pipeline. One simple way is to trigger it on every commit. There is also a special way called merge request pipelines. These types of pipelines are triggered only when a merge request is created.

In our case, we create a merge request immediately when we start working on the feature/issue. So whenever we make a commit to the branch, the pipeline gets triggered.

There is an option in the settings called "merge when pipelines succeed". It will only merge the code in the target branch if the pipeline successfully executes.

But in our case, we had to perform integration tests on the Design node and the pre-production node, and these tests were time-consuming (taking nearly 1–2 hours per country). So we decided to just run the automated unit tests and syntax checks using the very popular library called pre-commit.

We wanted to perform integration tests only when the product owner decides to merge the code from the feature branch to the development branch. This can be done using the merge trains feature in GitLab. There are a vast number of customizations you can do with the configurations.

### Pipeline Configurations

Here are the parameters we will use for this project:

* `DSS_PROJECT` (String): key of the project we want to deploy (e.g., `DIGIT_RECOGNIZER`)
* `DESIGN_URL` (String): URL of the design node (e.g., `https://dss-design.com/`)
* `DESIGN_API_KEY` (Password): Personal API key to connect to this node
* `AUTO_PREPROD_ID` (String): ID of the pre-production node as known by the Project Deployer
* `AUTO_PREPROD_URL` (String): URL of the PREPROD node (e.g., `https://dss-preprod.com/`)
* `AUTO_PREPROD_API_KEY` (Password): the API key to connect to this node
* `AUTO_PROD_ID` (String): ID of the production node as known by the Project Deployer
* `AUTO_PROD_URL` (String): URL of the PROD node (e.g., `https://dss-prod.com/`)

## MLOps Architecture

Our architecture contains:

* A Code Repository (GitLab)
* Two Dataiku Automation Nodes. One for Pre-Production and the other for Production
* One Dataiku Design Node

*MLOps Architecture: CI/CD Pipeline*

## Stages

The pipeline comprises:

* Jobs, which define what to do. For example, the job of compiling the code.
* Stages, which define when to run the jobs. For example, the stage that runs the unit tests after the code compilation.

In this project, there are 5 stages:

1.  A `PREPARE` stage, with a job called `prepare-workspace`.
2.  A `PROJECT_VALIDATION` stage, with four jobs called `syntax-checks`, `unit-tests`, `check-scenario`, and `update-git-references`.
3.  A `CREATE_BUNDLE` stage, with a job called `package-bundle`.
4.  A `PREPROD_TEST` stage, with a job called `deploy-to-test`.
5.  A `DEPLOY_TO_PROD` stage, with a job called `deploy-to-prod`.

### 1. 'PREPARE' Stage

This stage is used to build a proper workspace. The dependencies are installed using `requirements.txt`. To create and deploy the bundle, you need a `BUNDLE_NAME`. To access the `BUNDLE_NAME` in other jobs, save it in `variables.env` and store the file as an artifact.

To run your scripts, runners need to pull the required docker image from the Docker Hub. To reduce the time to pull an image and avoid getting rate-limited, we can build our docker image and download it in GitLab's container registry.

There are two ways to use docker images with CI:

* Use Docker to build Docker Images
* Use Kaniko to build Docker Images

Using Kaniko is the recommended way and we are using the same way.

### 2. 'PROJECT_VALIDATION' Stage

This stage contains mostly Python scripts used to validate that the project respects internal rules for being production-ready. Any check can be performed in this stage, be it on the project structure or the coding parts.

The first job is to check syntax using pre-commit hooks. We run a command `pre-commit run --all-files` to run the hooks on all the files in the project directory. You can find the sample configuration [here](#). We have also used a fast Python linter written in Rust [https://beta.ruff.rs/docs/usage/](https://beta.ruff.rs/docs/usage/).

We used pytest capability to use command line arguments by adding `conftest.py`. We can load our command line options using the `conftest.py` and use `run_test.py` to run our tests. We have some `TEST_SCENARIO`s in place to do integration and smoke tests.

### 3. 'CREATE_BUNDLE' Stage

This stage is to create the project bundle and publish it to the project deployer. Bundle contents include metadata of the input datasets, recipes, scenarios, Python scripts, etc. It's like the workflow's skeleton. Read about the bundle and its contents [here](#).

We export the bundle and then publish it to the project deployer. We can also download the zip files and store them for archiving purposes in our artifact repository.

### 4. 'PREPROD_TEST' Stage

At this stage, we deploy the bundle produced to the PREPROD/staging environment and run tests.

First, we check if the project is already deployed. If it is, we update the bundle; otherwise, we create a new deployment.

As mentioned before, we deploy a different workflow for each country, so we need to test these workflows before deploying the project to production. In this stage, we run a full test of the `TEST_SCENARIO` on each country that requires deployment. We use `git diff` to identify which country requires deployment and has been changed.

### 5. 'DEPLOY_TO_PROD' Stage

In this stage, we deploy our bundle to the production node after validating the package in the previous stage. Similar to previous stages, we have a Python script that handles the deployment to production. If there is a failure, we can roll back the deployment by activating the previously validated bundle and discarding the current one.

In production, we run scenarios that have time triggers in place. We monitor the workflows and store the results in Snowflake.

## Summary

Dataiku is a user-friendly platform for developing AI/ML apps that can be used with any code repository. You can build complex workflows, implement CI/CD, perform data validation, use built-in or custom models, monitor performance, and more. We created a CI/CD pipeline that increased our deployment frequency by 75% and reduced deployment time by 50%. These are pretty awesome gains!

## References

* [1] Tutorial &mdash; Jenkins pipeline for Dataiku with the Project Deployer
* [2] GitLab CI/CD
* [3] Developer Guide
