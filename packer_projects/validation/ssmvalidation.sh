#!/bin/bash 

# Validate if SSM agent is running on the instance

sudo systemctl status amazon-ssm-agent | tee agent.log

ssmstatus=$(egrep 'Active\:\sactive' agent.log | cut -d ' ' -f5)

if [ $ssmstatus eq 'active' ]; then 
  VALIDATION=true
else
  VALIDATION=false
fi




