#!/bin/bash
#
# example:
# $ IFC=0.0.0.0 bash docker_run_smartenv_shell.sh

### docker arguments ###
if [ -z "${1}" ] && [ -z "${CPORT+x}" ];
then 
	export CPORT=30303
elif [ ! -z "${1}" ];
then
	export CPORT="${1}"
fi

if [ -z "${2}" ] && [ -z "${HPORT+x}" ];
then 
	export HPORT=30303
elif [ ! -z "${2}" ];
then
	export HPORT="${2}"
fi

# Specify if expose port to local interface only
# or all interfaces 
if [ -z "${3}" ] && [ -z "${IFC+x}" ];
then 
	export IFC=127.0.0.1
	#export IFC=0.0.0.0
elif [ ! -z "${3}" ];
then
	export IFC="${3}"
fi


# Setup init
DATADIR="datadir/bob/"
NETID="1337"
NODEID="bob"
cp genesis_config/go-ethereum/genesis.json ${DATADIR}genesis.json
mkdir -p logs

docker run \
  -p ${IFC}:${CPORT}:${HPORT} \
  -p 127.0.0.1:8545:8545 \
  -p 127.0.0.1:8546:8546 \
  --mount type=bind,source=$(pwd),target=/smartenv \
  --net smartnet \
  --hostname smartenv \
  --ip 172.18.0.5 \
  -it smartenv:latest geth \
  	--identity "${NODEID}" \
	--networkid "${NETID}" \
	--datadir "${DATADIR}" \
	--verbosity 6 \
	init "${DATADIR}/genesis.json" \
	2>&1 | tee "logs/${NODEID}_$(date -Is)_init.log"
