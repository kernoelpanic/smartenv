# Smartenv

Environment for local/private ethereum chains 
Default environment is using `geth`

## Install docker ce 

https://docs.docker.com/engine/install/ubuntu/

## Build docker image 

The next step is building the docker image for the container that is running the ethereum node. 
It is possible to use already available go-ethereum sources (and builds) located in this directory
in a folder named `go-ethereum`. If such a folder is not available the current sources will be fetched. 
It is also possible to provide a specific version tag to the docker build script. 
```bash
$ DOCKERFILE=smartenv.geth.stable.Dockerfile VERSIONTAG=v1.9.23 bash docker_build_smartenv.sh
```

## Create accounts 
TODO

## Parameterize node
TODO


