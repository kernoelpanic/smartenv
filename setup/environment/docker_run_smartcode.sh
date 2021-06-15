#!/bin/bash

if [ -z "${1}" ] && [ -z "${CPORT+x}" ];
then 
	export CPORT=8888
elif [ ! -z "${1}" ];
then
	export CPORT="${1}"
fi

if [ -z "${2}" ] && [ -z "${HPORT+x}" ];
then 
	export HPORT=8888
elif [ ! -z "${2}" ];
then
	export HPORT="${2}"
fi


docker run \
  -p 127.0.0.1:${CPORT}:${HPORT} \
  --mount type=bind,source=$(pwd),target=/smartcode \
  --net smartnet \
  --hostname smartcode \
  --ip 172.18.0.3 \
  -it smartcode:latest
