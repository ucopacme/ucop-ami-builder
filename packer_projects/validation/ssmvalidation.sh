#!/bin/bash 

# Validate if SSM agent is running on the instance

VALIDATION=true

sudo systemctl status amazon-ssm-agent | tee agent.log

ssmstatus=$(egrep 'Active\:\sactive' agent.log | cut -d ' ' -f5)

if [ $ssmstatus ]; then 
  VALIDATION=true
else
  VALIDATION=false
  echo 'ssm validation failed'
  exit 1
fi


