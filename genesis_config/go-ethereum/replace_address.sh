#!/bin/bash
# 
if [ -z "${1}" ] && [ -z "${GENESISFILE+x}" ];
then
	echo "GENESISFILE = No gensis file given'"
	echo "first argument must be genesis file"
	exit 1	
elif [ ! -z "${1}" ];
then
	export GENESISFILE="${1}"
fi
echo "GENESISFILE = ${GENESISFILE}"

if [ -z "${2}" ] && [ -z "${ADDRESS+x}" ];
then
        echo "ADDRESS = No replacement address given'"
        echo "second argument must be address"
        exit 2  
elif [ ! -z "${2}" ];
then
        export ADDRESS="${2}"
fi
echo "ADDRESS     = ${ADDRESS}"

if test -f ${GENESISFILE};
then
	echo "Replacing ..."
	sed -i "s/ADDRESS/${ADDRESS}/g" ${GENESISFILE}
else
	echo "No such file"
fi
