<!-- ALL-CONTRIBUTORS-BADGE:START - Do not remove or modify this section -->
[![All Contributors](https://img.shields.io/badge/all_contributors-1-orange.svg?style=flat-square)](#contributors-)
<!-- ALL-CONTRIBUTORS-BADGE:END -->

Smartenv
========

This repository holds the setup for some local/private Ethereum test networks of different kinds,
including a smart contract crash course and exercises in form of challenges (without solutions ;)

The setup guide for this repository can be viewed from two perspectives:

* As a **[tutor](./README_TUTOR.md)** who wants to setup the challenge environment for *participants*.

* As a **[participant](./general_info/README.md)** who just wants to learn about smart contracts on Ethereum 
by solving the challenges in this repository, which have been setup by a tutor. 

In **any case** you will need to satisfy the following requirements: 
* Your favorite Linux distribution (tested on Ubuntu 20.04 Focal) with some system tools installed 
* A working **docker ce** installation

Just read along to learn how to setup your environment for making the crash course or running the challenges. 

## 1) Setup Linux System Environment

Most of the tools needed in the shell scripts should already be present 
on a standard installation. The following system tools might additionally 
be required:
```bash
$ apt-get install pwgen
```

## 2) Install Docker CE 

Install docker according to your respective Linux distribution:

https://docs.docker.com/engine/install/ubuntu/

## 3) Build docker Images

The next step is building the docker images for the containers that are running Ethereum nodes and our development environment. Note that the build and run shell scripts for the containers use the current user/group to map this directory into the running container later. So make sure the user who builds the containers is the same user that will run the containers later. Also 
make sure that this user can run docker containers i.e., is in the group `docker`. 

### go-ethereum docker container (`smartenv`)
It is possible to use already available [go-ethereum sources](https://github.com/ethereum/go-ethereum) (and builds) located in this directory in a folder named `go-ethereum`. 
If such a folder is not available the current sources will be fetched. 
It is also possible to provide a specific version tag to the docker build script. 
The latest version this has been tested is:

**v1.10.3**.

The docker file ([smartenv.geth.latest.Dockerfile](./smartenv.geth.latest.Dockerfile)) which configures this container can also be provided.

```bash
$ DOCKERFILE=smartenv.geth.latest.Dockerfile VERSIONTAG=v1.10.3 bash docker_build_smartenv.sh
```

If you check out the docker file, you see the detailed step-by-step guide for setting up a build environment for `geth` and compile the `go-ethereum` client from scratch. 
This would not be necessary when relying on binaries or ready to use containers provided by the developers. But since we are here to learn something :) this approach provides the largest degree of flexibility and customization. 


### development (web3.py) docker container (`smartcode`)
This container hosts our [web3.py](https://pypi.org/project/web3/) development environment and spawns a `jupyter` notebook to interact with our client (or PoA consensus node). 

```bash
$ bash docker_build_smartcode.sh
```

Again, to see what useful additional tools are installed check out the docker file [smartcode.python.latest.Dockerfile](./smartcode.python.latest.Dockerfile).


### Ganache docker container (`ganache-cli`)
Our development container requires either a full node to connect to or a `ganache` test node
to connect to. This will fetch the latest Ganache container from docker hub. 

```bash
$ bash docker_build_ganache.sh
```

## 4) Setting up the Challenge Environment

If docker and the containers have been setup you are free to continue depending on what you want to do.

* If you are a **tutor** you have to set up the server/challenge environment for the participants: [Setup server environment](./README_TUTOR.md).
* If you are a **participant** you can continue to connect to the server/challenge environment setup by the tutor - lucky you :) 


## 5) Connection to the Custom Testnet

To connect to our private/custom Ethereum PoA testnet you need our *genesis block* [genesis.json](/smartcode/genesis_config/genesis.json). Do not modify this file. This file has to be identical, otherwise you will not be able to connect. 

First make sure the system time of your computer is correct, this is important for our PoA setup. 
Then initialize your client (bob), and run it which should automatically connect to our server.
```bash
$ cp genesis_config/go-ethereum/${ETH_VERSION}/genesis.json datadir/bob/genesis.json
$ ntpdate ntp.ubuntu.com
$ bash geth_init_bob.sh
```

Now copy your personal key file into the folder `datadir/bob/keystore` or create a new one
```bash
$ mkkdir -p ./datadir/bob/keystore && cp UTC--2021-06-07T13-09-53.517129020Z--33.... ./datadir/bob/keystore/ # copy existing account
$ PWFILE=./passwordfile DATADIR=./datadir/bob/ bash geth_account.sh new # create a new account
$ bash geth_run_bob.sh 
```

If you run `bob` on the same physical machine as `alice` (or the ports are already used by other software) take care to use another port. The HPORT is the port on the host machine, that is mapped/forwarded to the docker container port CPORT i.e., the client machine.  

```bash
$ HPORT=30301 CPORT=30301 bash geth_init_bob.sh
$ HPORT=30301 CPORT=30301 bash geth_run_bob.sh
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
$ bash docker_run_smartcode.sh 
[...]
    To access the notebook, open this file in a browser:
        file:///home/smartcode/.local/share/jupyter/runtime/nbserver-1-open.html
    Or copy and paste one of these URLs:
        http://smartcode:8888/?token=789c9d57894c62f7e8e62e95d6ef1c778f3e98dbb6818e17
     or http://127.0.0.1:8888/?token=789c9d57894c62f7e8e62e95d6ef1c778f3e98dbb6818e17
```

To also work with the `ganache-cli` in the crash course, start this container as well:

```bash
$ bash docker_run_ganache.sh
[...]
Listening on 0.0.0.0:8545
```

## 7) Solve the challenges

After having completed the crash course you can start working on the challenges. 
A task description can be found [here](./general_info/README.md). 

