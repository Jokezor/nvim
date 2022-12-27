# Neovim to work in Docker.

## Background
Built to work more easily with dockerized environments to be able to clone this repository on any machine having docker and edit like you would having installed and fixed everything with LSP.

Currently setup using Astro Nvim for quick setup:
https://github.com/AstroNvim/AstroNvim

Works by installing nvim and installing the python environment that is defined in the requirements.txt file.
Then you just need to build the Dockerfile and run nvim through bash in the docker shell to access nvim.

## Setup

First you need to build the docker container and tag it
1. docker build  -t docker_python_lsp .

Then it is a matter of running the docker container shell with the right volumes you want to access and make sure the Display environment is set

2. docker run -it  -e DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix -v /home/joakim/Documents/docker_python_lsp:/tmp docker_python_lsp

Finally, just run nvim to enter neovim from within the Docker container

3. nvim .


## How to use it

From following the setup, you will have a docker container built that you can run nvim through.
But for setting up the LSP and formatters you need to use the AstroNvim setup:

https://github.com/AstroNvim/AstroNvim#-basic-setup

Some noteworthy plugins to run are

Intalling the python LSP server

1. LspInstall pyright

Installing python language parser

2. TSInstall python


## Examples
Here is an example after installing pyright and python, where you can go into internal django code and have it open it up in the explorer to show where it is in the external library:

![image](https://user-images.githubusercontent.com/22026527/209632025-cb93ad47-fa46-487c-9cda-c58625a7fca1.png)
