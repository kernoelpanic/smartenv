#!/bin/bash
# Takes three optional arguments:
# 1. Port in container to expose (default=8888)
# 2. Port on host to expose the respective container port (default=8888)
# 3. User ID of user in container  (default=1000)

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

if [ -z "${3}" ] && [ -z "${USER_ID+x}" ];
	then 
		USER_ID=1000
	else 
		# use --user 0 to get a root shell
		USER_ID=${3}
fi

docker run \
  -p 127.0.0.1:${CPORT}:${HPORT} \
  --mount type=bind,source=$(pwd),target=/smartcode \
  --net smartnet \
  --hostname smartcode \
  --ip 172.18.0.3 \
  --user ${USER_ID} \
  -it smartcode:latest /bin/bash
