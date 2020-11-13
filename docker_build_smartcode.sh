#!/bin/bash
# Setup docker environment for tutorial
set -e

# pull required images
#docker pull ubuntu:focal
#docker pull trufflesuite/ganache-cli:latest
#docker pull parity/parity:stable

# Build smartcode
# Get uid and gid of current user
# In most cases this will be 1000
docker build --build-arg UID=$(id -u) --build-arg GID=$(id -g) -f smartcode.python.latest.Dockerfile -t smartcode:latest .

# check if network exists if not create it
DOCKER_NETWORK=$(docker network ls | grep "smartnet")
if [[ -z ${DOCKER_NETWORK} ]]; then
        docker network create --subnet=172.18.0.0/16 --driver bridge smartnet
fi
echo
docker network ls
echo
docker images 
