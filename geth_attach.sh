#!/bin/bash

set -e

# Check if geth runs in docker
# This is the default 
if [ -z "${DOCKER+x}" ];
then
    DOCKER=true
fi
echo "DOCKER = ${DOCKER}"

# rpcport
if [ -z "${1}" ] && [ -z "${RPCPORT+x}" ];
then
    echo "RPCPORT = No rpcport given e.g., '8545'"
    echo "Setting default:"
    export RPCPORT="8545"
elif [ ! -z "${1}" ];
then
    export RPCPORT="${1}"
fi
echo "RPCPORT = ${RPCPORT}"

if [ $DOCKER ]; then
  # find docker container and run geth attack in it
  if [ -z "${2}" ] && [ -z "${CONTAINERID+x}" ];
  then
    echo "CONTAINERID = No container ID given run 'docker ps'"
    echo "Setting default:"
    export CONTAINERID=$(docker ps | grep smartenv | cut -d' ' -f1)
  elif [ ! -z "${2}" ];
  then
    export CONTAINERID="${2}"
  fi
  echo "CONTAINERID = ${CONTAINERID}" 
  export GETH="docker exec -it ${CONTAINERID} geth "
else
  # just run geth and attach 
  export GETH="geth"
fi

# run geth
#${GETH} attach "http://localhost:${RPCPORT}"
${GETH} attach "http://127.0.0.1:${RPCPORT}"

