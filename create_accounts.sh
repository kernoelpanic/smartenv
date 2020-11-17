#!/bin/bash


if [ -z "${1}" ] && [ -z "${PARTICIPANTS+x}" ];
then
    echo "PARTICIPANTS = No number given e.g., '42'"
    exit 2
elif [ ! -z "${1}" ];
then
    export PARTICIPANTS="${1}"
fi

export DATADIR="./datadir/accountmgt"

echo "DATADIR = ${DATADIR}"
echo "PARTICIPANTS = ${PARTICIPANTS}"

mkdir -p "./generated_config/keystore/"

#for i in {0..90}};
for i in $(seq 1 ${PARTICIPANTS});
do 
	echo $i
	bash ./geth_account.sh new
done

cp -r ./datadir/accountmgt/keystore/* ./generated_config/keystore/
