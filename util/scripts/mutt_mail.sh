#!/usr/bin/bash

# Remember to temporarily enter the password for SMTP in the mutt config file used 
# to send mails:
#
# set smtp_pass = ""


PARTICIPATNS_CSV="${1}"

export IFS=","

tail -n+2 ${PARTICIPATNS_CSV} |  while read id to cc att kid; 
do  
    echo "Preparing mail for ${id}: ${to}";
    export IFS=" "
    export SUBJECT="Credentials for 052011-1 Security and Privacy Engineering"; 
    export BODY="
Hello,

The attachment of this mail contains your individual public/private key pair for the challenge
environment and some meta information, for 2022W 052011-1 Security and Privacy Engineering 

Further information will be given in the next lecture, and in moodle:

https://moodle.univie.ac.at/course/view.php?id=335437

Kind regards    
"; 
    echo ${BODY} > /tmp/BODY ;
    mutt -F $HOME/Mail/SBA/ajudmayer_sba-research.org -a ${att} -c ${cc} -s "${SUBJECT}" -- ${to} < /tmp/BODY ;
    export IFS=","
done 



