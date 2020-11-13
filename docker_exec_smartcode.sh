#!/bin/bash
# 
# Example usage:
#
# Get shell in running container smartcode:
# $ bash docker_exec_smartcode.sh
#
# Get root shell in running container smartcode:
# $ bash docker_exec_smartcode.sh smartcode 0

if [ -z "${1}" ]
	then
		CONTAINER_ID=$(docker ps | grep smartcode | cut -d" " -f1)
	else 
		CONTAINER_ID=$(docker ps | grep ${1} | cut -d" " -f1)
fi

if [ -z "${2}" ]
	then 
		USER_ID=1000
	else 
		# use --user 0 to get a root shell
		USER_ID=${2}
fi

docker exec \
  --user "${USER_ID}" \
  -it "${CONTAINER_ID}" \
  /bin/bash
