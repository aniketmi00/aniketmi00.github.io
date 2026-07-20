---
title: some basics of docker
date: '2024-06-14 18:30:00+00:00'
---

Docker is a tool that allows devs to deploy their apps easily in a container to run on any host OS. 
The benefit of Docker is that it packages an app with all its dependencies into a container.

Containers are highly efficient in terms of memory usage unlike VMs. 

## VMs

Provides isolation but has high resource overhead and slow boot times.

## Containers

Lightweight as they share OS, can be easily deployed.

This mechanism decouples the app from the environment in which they actually run allowing devs to easily deploy into public cloud, private data centre or even in their own laptop regardless of which OS they use.

- Docker daemon is the heart and manages. Similar to the k8s api server.
- Docker client is used to interact with the daemon.
- Images are the blueprints.
- Containers run the actual app.
- Docker Hub is the registry. Similar to AWS ECR.

## Installation

[Install Docker](https://docs.docker.com/engine/install/) based on the OS you have.

Once you install docker, you can test if it is installed correctly by running:

```bash
$ docker run hello-world
```

## Pull
[registry-url]/[namespace]/[image]:[tag]

```bash
$ docker pull docker pull pytorch/pytorch:2.3.1-cuda11.8-cudnn8-devel
```

only downloads those layers that haven't been cached locally

## Run
run the image in an interactive mode

```bash
$ docker run -it pytorch/pytorch:2.3.1-cuda11.8-cudnn8-devel
```

exit with `CTRL+D`

> you can ssh into running containers
> `docker exec -ti <container_id> bash`

listing all containers

```bash
$ docker ps
```
a useful variant is to use `-a`

> to run with GPUs pass `--gpus=all`

## Volumes
persists data beyond the container lifecycle

add `-v HOST_PATH:CONTAINER_PATH`to docker run command

For example, map the current dir to /opt/local

```bash
$ docker run \
    -v `pwd`:/opt/local \
    -it pytorch/pytorch:2.3.1-cuda11.8-cudnn8-devel
```

## Clean up

```bash
$ docker stop

$ docker stop $(docker ps -a -q)

$ docker rm

$ docker rmi
```

## Dockerfile

It's a text file that has all the commands

We start with specifying our base image:

```dockerfile
FROM pytorch/pytorch:2.3.1-cuda11.8-cudnn8-devel
```

We can pass ARG

```dockerfile
ARG key=value
```

for example

```dockerfile
ARG CUDA="11.8"

FROM pytorch/pytorch:2.3.1-cuda${CUDA}-cudnn8-devel

# set up a directory
WORKDIR /usr/src/app
```

We can also use ENV which persists within the docker image like `ENV DEBIAN_FRONTEND=noninteractive`

installing dependencies

```dockerfile
RUN pip install --no-cache-dir -r requirements.txt
```

next copy files

```dockerfile
# copy all the files to the container
COPY . .
```

expose the port 

```dockerfile
EXPOSE 5000
```

## Best practices

1. Use multi-stage builds to create leaner and more secure images.

2. Order commands properly.

3. Use smaller base images like python:3.8-slim.

4. Use COPY (copy local files from the Docker host to the image) over ADD (downloading external files).

5. Cache python packages using `--mount=type=cache,target=/root/.cache/pip`.

6. Run only one process per container.

7. Use `ENTRYPOINT` instead of CMD.

8. Use a `.dockerignore` file.

9. Use `docker scout` to scan the image for vulnerabilities.
