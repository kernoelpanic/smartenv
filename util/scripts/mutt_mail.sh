#!/usr/bin/bash

PARTICIPATNS_CSV="${1}"

export IFS=","

tail -n+2 ${PARTICIPATNS_CSV} |  while read id to cc att kid; 
do  
    echo "Preparing mail for ${id}: ${to}";
    export IFS=" "
    export SUBJECT="Credentials for DLEAD qualification seminar challenge and quiz environment"; 
    export BODY="
Hello,

The attachment of this mail contains your individual public/private key pair for the challenge
environment and some meta information, as well as the login token required for registration on the quiz homepage. 

The registration will open on day 1 of the seminar. 

Kind regards    
"; 
    echo ${BODY} > /tmp/BODY ;
    mutt -F $HOME/Mail/SBA/ajudmayer_sba-research.org -a ${att} -c ${cc} -s "${SUBJECT}" -- ${to} < /tmp/BODY ;
    export IFS=","
done 

