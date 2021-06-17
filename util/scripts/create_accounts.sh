#!/bin/bash
#
# Run from root of repository

set -e

if [ -z "${1}" ] && [ -z "${PARTICIPANTS+x}" ];
then
    echo "PARTICIPANTS = No number given e.g., '42'"
    exit 2
elif [ ! -z "${1}" ];
then
    export PARTICIPANTS="${1}"
fi
echo "PARTICIPANTS = ${PARTICIPANTS}"

if [ -z "${DATADIR+x}" ];
then
    echo "DATADIR environment variable missing"
	echo "No Datadir given e.g., './datadir/alice/'"
	exit 2
fi
echo "DATADIR = ${DATADIR}"

if [ -z "${TARGETDIR+x}" ];
then
        echo "TARGETDIR environment variable missing"
	echo "No Datadir given e.g., './setup/generated_config/keystore'"
	exit 2
fi
echo "TARGETDIR = ${TARGETDIR}"

mkdir -p ${TARGETDIR}

#for i in {0..90}};
for i in $(seq 1 ${PARTICIPANTS});
do 
	echo $i
	bash ./util/scripts/geth_account.sh new
done

cp -r "${DATADIR}/keystore" ${TARGETDIR}
