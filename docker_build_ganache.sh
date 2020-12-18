#!/bin/bash

docker pull trufflesuite/ganache-cli:latest

# check if network exists if not create it
DOCKER_NETWORK=$(docker network ls | grep "smartnet")
if [[ -z ${DOCKER_NETWORK} ]]; then
        docker network create --subnet=172.18.0.0/16 --driver bridge smartnet
fi
echo
docker network ls
echo
docker images

