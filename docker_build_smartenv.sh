#!/bin/bash
# Setup ethereum docker environment
# 
# Default is a geth environment with 
# the version tag specified in this file
# example:
# $ DOCKERFILE=smartenv.geth.stable.Dockerfile VERSIONTAG=v1.9.23 bash docker_build_smartenv.sh
set -e 

# Default docker file for smartenv is geth
if [ -z "${1}" ] && [ -z "${DOCKERFILE+x}" ];
then 
	export DOCKERFILE="smartenv.geth.stable.Dockerfile"
elif [ ! -z "${1}" ];
then
	export DOCKERFILE="${1}"
fi

if [ -z "${2}" ] && [ -z "${VERSIONTAG+x}" ];
then
	export VERSIONTAG="v1.9.23"
elif [ ! -z "${2}" ];
then
	export VERSIONTAG="${2}"
fi

mkdir -p go-ethereum
mkdir -p openethereum 

docker pull ubuntu:focal

# Build smartenv
# Get uid and gid of current user
# In most cases this will be 1000
docker build --build-arg UID=$(id -u) --build-arg GID=$(id -g) --build-arg VERSIONTAG=$VERSIONTAG -f $DOCKERFILE -t smartenv:latest .

# check if network exists if not create it
DOCKER_NETWORK=$(docker network ls | grep "smartnet")
if [[ -z ${DOCKER_NETWORK} ]]; then 
	docker network create --subnet=172.18.0.0/16 --driver bridge smartnet
fi
echo
docker network ls
echo
docker images 
