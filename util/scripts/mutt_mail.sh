#!/usr/bin/bash

PARTICIPATNS_CSV="${1}"

export IFS=","

tail -n+2 ${PARTICIPATNS_CSV} |  while read id to cc att kid; 
do  
    echo "Preparing mail for ${id}: ${to}";
    export IFS=" "
    export SUBJECT="Credentials for Advanced Topics in Internet Computing & Software Technologies"; 
    export BODY="
Hello,

The attachment of this mail contains your individual public/private key pair for the challenge
environment and some meta information, for 2021W 052520-1 Advanced Topics in Internet Computing & Software Technologies 

Further information will be given in the next lecture, and in moodle:

https://moodle.univie.ac.at/course/view.php?id=259881

Kind regards    
"; 
    echo ${BODY} > /tmp/BODY ;
    mutt -F $HOME/Mail/SBA/ajudmayer_sba-research.org -a ${att} -c ${cc} -s "${SUBJECT}" -- ${to} < /tmp/BODY ;
    export IFS=","
done 

