#!/bin/bash
#
#
# Run with docker:
# $ PWFILE=./passwordfile DATADIR=./datadir/accountmgt/ bash geth_account.sh new

if [ -z "${PWFILE+x}" ];
then
	echo "PWFILE environment variable missing"
	echo "No Password file given e.g., './passwordfile'"
	exit 1 
fi
echo "PWFILE = ${PWFILE}"

if [ -z "${DATADIR+x}" ];
then
        echo "DATADIR environment variable missing"
	echo "No Datadir given e.g., '/datadir/alice/'"
	exit 2
fi
echo "DATADIR = ${DATADIR}"

# run container without network
# just to generate and manage keys
docker run \
	--mount type=bind,source=$(pwd),target=/smartenv \
	--net smartnet \
	--hostname smartenv \
	--ip 172.18.0.5 \
	-it smartenv:latest \
		geth \
		--datadir "${DATADIR}" \
		--nodiscover \
		--maxpeers 0 \
		--ipcdisable \
		--verbosity 6  \
		--password "${PWFILE}" \
		account "$1" "$2" "$3" 

