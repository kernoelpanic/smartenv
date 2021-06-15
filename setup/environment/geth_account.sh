#!/bin/bash
#
#
# Run with docker:
# $ PWFILE=./passwordfile DATADIR=./datadir/accountmgt/ bash geth_account.sh new

if [ -z "${PWFILE+x}" ];
then
	echo "PWFILE environment variable missing"
	echo "No Password file given using default './passwordfile'"
	export PWFILE='./passwordfile'
fi
echo "PWFILE = ${PWFILE}"

if [ -f "${PWFILE}" ];
then
	echo "using stored password ... "	
else
	pwgen -s -B 32 1 > ${PWFILE}
fi

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
	-it smartenv:latest \
		geth \
		--datadir "${DATADIR}" \
		--nodiscover \
		--maxpeers 0 \
		--ipcdisable \
		--verbosity 6  \
		--password "${PWFILE}" \
		account "$1" "$2" "$3" 

