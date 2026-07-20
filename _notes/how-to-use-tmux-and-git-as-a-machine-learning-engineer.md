---
title: how to use tmux and git as a ml engineer
date: '2022-08-01 18:30:00+00:00'
---

This post is the continuation of [how to setup a machine for deep learning in a correct way](link to previous post). You can check it out first before moving on to this post.

In the last post, we installed pytorch and jupyter lab in our machine. In this post, we will look into:

* How to switch between different users
* Create repository on Github
* SSH and HTTPS
* Copy the repo on the local filesystem
* Tmux
* Push changes to Github

## Switch between users

You can have multiple users and the way to switch between them is to use:

```bash
sudo -u <usernam> -i
````

but having multiple users is not recommended though.

## Git and GitHub

Git is the version control system where we can commit versions of our code. On Github, you can see the diff between different commits.

To start, you have to first create a new repository on the [Github repositories page](link to Github repositories page).

You have the option to add `README.md` which is a markdown file that describes the repository.

You can select python as the `.gitignore` template which has the files you want git to ignore. Like AWS credentials, `.ipynb checkpoints`, etc.

You can also add the `License`. Typically, you should use the Apache 2.0 under which you can use the code commercially without getting sued for patent infringement.

## Github repository

To **clone** or copy the existing repo into the local filesystem use:

```bash
git clone git@github.com:aniket-mish/my-project.git
cd my-project
# start working on the project
```

You can learn about git commands [here](link to git commands documentation).

You have to use SSH to clone the git repo.

## SSH to clone the repository

When you try cloning the repo you will get an error that says permission denied. This is because ssh needs to know the identity of the computer so that you should not access something you are not meant to.

\![Permission denied to clone](link to permission denied image)

There is another way to clone a repo using the HTTPS protocol.

## HTTPS to clone the repository

This way it is possible to clone without the private key but when you try to save the changes back to the repo, Github will ask for the username and password of the account which you will not have as this is someone else’s repository.

SSH does not use passwords. It uses a secret key called a private key as an identity of the computer. The public key is given to other people so that you can access their repo but they can’t access ours.

To create a private and public key for ssh, you have to enter the command `ssh-keygen`. There is no need to enter all the other details.

```bash
ssh-keygen
```

This creates a private key for the specific computer and a public key which tells Github who you are.

\![Create a private and public key for SSH clone](link to ssh-keygen image)

Copy the public key and paste it under the SSH key on the settings page of Github.

\![Setting panel to add SSH keys](link to github settings image)

Now if you try cloning the repo, it will get successfully cloned.

\![Git clone using SSH](link to successful clone image)

These are some of the tricks you can use to zip through the directories.

  * `pushd` — to save the directory
    Then you `cd` into multiple directories and then
  * `popd` — to get back to the saved directory

Another tip is to use a consistent name and email in the `.gitconfig`. The commits from the verified email are tagged as verified.

## Tmux

Now, if you are running a jupyter lab session and you want to do some other tasks, you will need to open a new terminal session. Instead, use `tmux`.

tmux lets you switch easily between several programs in one terminal, detach them (they keep running in the background), and reattach them to a different terminal.

To install tmux on a Mac:

```bash
brew install tmux
```

To install brew, check [here](link to brew installation instructions).

On Linux:

```bash
sudo apt install tmux
```

Tip — Open jupyter lab from the notebooks folder

To start a new tmux session:

```bash
tmux new
```

Here are a few help keys for using tmux efficiently:

  * `ctrl + b + %` — Split terminal horizontally
  * `ctrl + b + “` — Split terminal vertically
  * `ctrl + d` — Exit the program/terminal
  * `ctrl + b + Up/Down/Left/Right` — Select the panes
  * `ctrl + b + z` — Maximize/minimize a particular pane
  * `ctrl + b + d` — Detach and close the terminals
  * `tmux a` — Attach

\![Tmux terminal with multiple panes to switch](link to tmux image)

You can also split panes and ssh into multiple servers.

You can check out more help keys [here](link to tmux help keys).

## Git cycle

If you need to push your changes to a git repository, then you need to follow the steps which are mentioned below.

```bash
git status
```

\![git status](link to git status untracked image)

Here the app.py is an untracked file.

```bash
git add app.py
```

or

```bash
git add .
```

Now after the above command, app.py is staged for committing to the repo. You can use a filename to add or you can use a period after add to commit all the files that are untracked.

```bash
git commit -m "first commit"
```

\![git commit -m "message"](link to git commit image)

after committing the file, you can see that there are no more untacked files. These changes are now committed to the git of local filesystem.

```bash
git push
```

or

```bash
git push origin main
```

Now you have to push the committed changes to the remote git repository on the Github.

```bash
git status
```

Finally, you can check the status and see that the branch is up to date with the latest changes. You can see the file `app.py` under the git repository.

\![Github repo after pushing changes](link to github repo after push image)

These posts are the learnings from [@Jeremy Howard’s youtube video series](link to youtube series) which you should definitely check out.
