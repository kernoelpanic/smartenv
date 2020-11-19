# Smartenv

This repository holds the setup for a local/private Ethereum test networks of different kinds,
including a smart contract crash crourse and exercies in form of challenges (without solutions ;)

The setup guid for this repository can be view from two perspectives:

* As a **[tutor](./README_TUTOR.md)** who wants to setup the challenge environment for *participants*.

* As a **[participant](./general_info/README.md)** who just wants to learn about smart contracts on Ethereuem 
by solving the challenges in this repository, which have been setup by a tutor. 

In **any case** you will need to satisfy the following requirements: 
* Your favorite Linux distribution (tested on Ubuntu 20.04 Focal) with some system tools installed 
* A working **docker ce** installation

## Setup Linux environment

Most of the tools needed in the shell scripts should alread be present 
on a standard installation. The follwing system tools might additionally 
be required:
```bash
$ apt-get install pwgen
```

## Install docker ce 

Install docker according to your respective Linux distribution:

https://docs.docker.com/engine/install/ubuntu/

## Build docker images

The next step is building the docker images for the containers that are running Ethereum nodes and our development environment. Note that the build and run shell scripts for the containers use 
the current user/group to map this directory into the running container later. 
So make sure the user who builds the containers is the same user that will run the containers later. 

### go-ethereum docker container
It is possible to use already available [go-ethereum sources](https://github.com/ethereum/go-ethereum) (and builds) located in this directory
in a folder named `go-ethereum`. 
If such a folder is not available the current sources will be fetched. 
It is also possible to provide a specific version tag to the docker build script. 
The latest version this has been tested is **v1.9.23**.
The docker file ([smartenv.geth.latest.Dockerfile](./smartenv.geth.latest.Dockerfile)) which configures this container can also be provided.

```bash
$ DOCKERFILE=smartenv.geth.stable.Dockerfile VERSIONTAG=v1.9.23 bash docker_build_smartenv.sh
```

If you check out the docker file, you see the detailed step-by-step guide for setting up a build environment for `geth` and compile the `go-ethereum` client from scratch. 
This would not be necessary when relying on binaries or ready to use containers provided by the developers. But since we are here to learn something :) this approach provides the largest degree of flexibility and customization. 


### development (web3.py) docker container 
This container hosts our [web3.py](https://pypi.org/project/web3/) development environment and spawns a `jupyter` notebook to interact with our client (or PoA consensus node). 

```bash
$ bash docker_build_smartcode.sh
```

Again, to see what useful additional tools are installed check out the docker file [smartcode.python.latest.Dockerfile](./smartcode.python.latest.Dockerfile).


### ganache docker container 
Our development container requires either a full node to connect to or a `ganache` test node
to connect to. This will fetch the latest ganache container from docker hub. 

```bash
$ bash docker_build_ganache.sh
```


## Continue ...

If docker and the containers have been setup you are free to continue depending on what you want to do:

* Continue as [Tutor](./README_TUTOR.md) setting up the environment for participants ...
* Continue as [participant](./general_info/README.md) solving the challenges ... 

