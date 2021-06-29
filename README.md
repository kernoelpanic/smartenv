<!-- ALL-CONTRIBUTORS-BADGE:START - Do not remove or modify this section -->
[![All Contributors](https://img.shields.io/badge/all_contributors-1-orange.svg?style=flat-square)](#contributors-)
<!-- ALL-CONTRIBUTORS-BADGE:END -->

Smartenv
========

This repository holds the setup for some local/private Ethereum test networks of different kinds,
including a smart contract crash course and exercises in form of challenges (without solutions ;)

The setup guide for this repository can be viewed from two perspectives:

* As a *tutor* who wants to setup the challenge environment for *participants*.

* As a *participant* who just wants to learn about smart contracts on Ethereum 
by solving the challenges in this repository, which have been setup by a tutor. 

In **any case** you will need to satisfy the following requirements. 
Just read along to learn how to setup your environment for making the crash course or running the challenges. 

## 1) Setup Linux System Environment

Your favorite Linux distribution (tested on Ubuntu 20.04 Focal) with some system tools installed is 
the basic requirement. Most of the tools needed in the shell scripts should already be present 
on a standard installation. The following system tools might additionally 
be required:
```bash
$ apt-get install make pwgen 
```

## 2) Install Docker CE 

Install docker according to your respective Linux distribution:

* https://docs.docker.com/engine/install/ubuntu/

Consider also to run docker as user and not as root like so:

* https://docs.docker.com/engine/install/linux-postinstall/


## 3) Build docker Images

The next step is building the docker images for the containers that are running Ethereum nodes and our development environment. Note that the build and run shell scripts for the containers use the current user/group to map this directory into the running container later. So make sure the user who builds the containers is the same user that will run the containers later. Also 
make sure that this user can run docker containers i.e., is in the group `docker`. 

### go-ethereum docker container (`smartenv`)
It is possible to use already available [go-ethereum sources](https://github.com/ethereum/go-ethereum) (and builds) located in this directory in a folder named `src-clients/go-ethereum`. 
If such a folder is not available the current sources will be fetched. 
It is also possible to provide a specific version tag to the docker build script. 
The latest version this has been tested is:

**v1.10.3**.

The docker file ([smartenv-geth.latest.Dockerfile](./setup/environment/dockerfiles/smartenv-geth.latest.Dockerfile)) which configures this container can also be provided.

```bash
$ make build-smartenv-geth GETH_VERSIONTAG=v1.10.3
```

If you are running your `docker` commands as root. Please specify the `UID` and `GID` of 
the user running in the container manually. Otherwise the `UID` and `GID` of the current user is used in the container as well. 
Ideally you specify the `UID` and `GID` of the user with which you have checked out this repository and plan to work in this environment. Usually this will be `UID=GID=1000` 


```bash
$ DOCKER_UID=1000 DOCKER_GID=1000 make build-smartenv-geth GETH_VERSIONTAG=v1.10.3
```

If you check out the docker file, you see the detailed step-by-step guide for setting up a build environment for `geth` and compile the `go-ethereum` client from scratch. 
This would not be necessary when relying on binaries or ready to use containers provided by the developers. But since we are here to learn something :) this approach provides the largest degree of flexibility and customization. 


### development (web3.py) docker container (`smartcode`)
This container hosts our [web3.py](https://pypi.org/project/web3/) development environment and spawns a `jupyter` notebook to interact with our client (or PoA consensus node). 

```bash
$ make build-smartenv-web3py
```

Again, to see what useful additional tools are installed check out the docker file [smartenv-web3py.latest.Dockerfile](./setup/environment/dockerfiles/smartenv-web3py.latest.Dockerfile).


### Ganache docker container (`ganache-cli`)
Our development container requires either a full node to connect to or a `ganache` test node
to connect to. This will fetch the latest Ganache container from docker hub. 

```bash
$ make build-ganache-cli
```

### Setup docker network
To allow communication between the docker containers lets create a new bridged docker network. 
```bash
$ make network
```

## 4) Setting up the Challenge Environment

If docker and the containers have been setup you are free to continue depending on what you want to do.

* If you are a **tutor** you have to set up the server/challenge environment for the participants: [Setup server environment](./README_TUTOR.md).
* If you are a **participant** you can continue to connect to the server/challenge environment setup by the tutor - lucky you :) 


## 5) Connection to the Custom Testnet

To connect to our private/custom Ethereum PoA testnet you need our *genesis block* [genesis.json](./setup/environment/genesis_config/go-ethereum/berlin/genesis.json). Do not modify this file. This file has to be identical, otherwise you will not be able to connect. 

First make sure the system time of your computer is correct, this is important for our PoA setup. 
Then initialize your client (bob), and run it which should automatically connect to our server.
```bash
$ cp ./setup/environment/genesis_config/go-ethereum/${ETH_VERSION}/genesis.json datadir/bob/genesis.json
$ ntpdate ntp.ubuntu.com
$ make init-smartenv-geth-bob
```

Now copy your personal key file into the folder `datadir/bob/keystore` and use the `passwordfile` you recieved via e-mail.
Alternatively, you can create a new one, using your own `passwordfile` like so: 
```bash
$ mkdir -p ./datadir/bob/keystore && cp UTC--2021-06-07T13-09-53.517129020Z--33.... ./datadir/bob/keystore/ # copy existing account
$ PWFILE=./passwordfile DATADIR=./datadir/bob/ bash ./util/scripts/geth_account.sh new # or reate a new account
$ make run-smartenv-geth-bob
```

If you run `bob` on the same physical machine as `alice` (or the ports are already used by other software) take care to use another port. 
This can be done by providing the appropiate environment variable on the command line before calling the `make run-..` command.  

```bash
DOCKER_PORT_GETH_BOB ?= 30303
HOST_PORT_GETH_BOB ?= 30303
DOCKER_RPCPORT_GETH_BOB ?= 8545
HOST_RPCPORT_GETH_BOB ?= 8545
DOCKER_WSPORT_GETH_BOB ?= 8546
HOST_WSPORT_GETH_BOB ?= 8546
```

You can test now if `bob` is able to connect to `alice`. 
Currently the run script for bob is configured to connect to our server at the University. 


### Check if successfully connected

The peer count must be at least 1, and there should already be some blocks synchronized. 

```bash
$ bash geth_attach.sh
> net.peerCount
1
> eth.blockNumber
634
> admin.peers
[...]
> admin.nodeInfo
[...]
```

## 6) Go through the Crash Course 

As a participant you can now go through the crash course on how to interact with `geth` and `ganache`
and the Ethereum ecosystem. Therefore you have to start the docker container which provides
a development environment. This container fires up a jupyter notebook to which you can connect to from your browser. 

```bash
$ make run-smartenv-web3py 
[...]
    To access the notebook, open this file in a browser:
        file:///home/smartcode/.local/share/jupyter/runtime/nbserver-1-open.html
    Or copy and paste one of these URLs:
        http://smartcode:8888/?token=789c9d57894c62f7e8e62e95d6ef1c778f3e98dbb6818e17
     or http://127.0.0.1:8888/?token=789c9d57894c62f7e8e62e95d6ef1c778f3e98dbb6818e17
```

To also work with the `ganache-cli` in the crash course, start this container as well:

```bash
$ make run-ganache-cli
[...]
Listening on 0.0.0.0:8545
```

## 7) Solve the challenges

After having completed the crash course you can start working on the challenges. 
A task description can be found [here](./README_CHALLENGES.md). 

