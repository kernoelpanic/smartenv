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
	#export IFC=127.0.0.1
	export IFC=0.0.0.0
elif [ ! -z "${3}" ];
then
	export IFC="${3}"
fi


# Setup run
mkdir -p logs
DATADIR="datadir/alice/"
NETID="1337"
NODEID="alice"
ADDRESS="0xe63419B7c0be62A6127923fb70C32A5ca1926a16"
PASSWORDFILE="./passwordfile"
# --
RPCPORT=8545
RPCIFC="0.0.0.0"
WSPORT=8546
WSIFC="0.0.0.0"
PORT=$CPORT

docker run \
  -p ${IFC}:${CPORT}:${HPORT} \
  -p 127.0.0.1:${PRCPORT}:${RPCPORT} \
  -p 127.0.0.1:${WSPORT}:${WSPORT} \
  --mount type=bind,source=$(pwd),target=/smartenv \
  --net smartnet \
  --hostname smartenv \
  --ip 172.18.0.5 \
  -it smartenv:latest geth \
  	--identity "${NODEID}" \
	--networkid "${NETID}" \
	--datadir "${DATADIR}" \
	--http \
	--http.port "${RPCPORT}" \
	--http.addr "${RPCIFC}" \
	--http.api "eth,net,web3,personal,debug,admin,miner,txpool,clique" \
	--http.corsdomain "*" \
	--http.vhosts "*" \
	--ws \
	--ws.port "${WSPORT}" \
	--ws.addr "${WSIFC}" \
	--ws.api "eth,net,web3,personal,debug,admin,miner,txpool,clique" \
	--ws.origins "*" \
	--unlock "${ADDRESS}" \
	--password "${PASSWORDFILE}" \
	--allow-insecure-unlock \
	--mine \
	--ipcdisable \
	--nodiscover \
	--metrics \
	--verbosity 6 \
	console \
	2>&1 | tee "logs/${NODEID}_$(date -Is)_run.log"
