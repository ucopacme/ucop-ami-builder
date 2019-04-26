#!/bin/bash 
####!/usr/bin/env bash 
PATH=$PATH:/usr/bin:/bin

VALIDATION=true

# Validate if SSM agent is running on the instance
#systemctl status amazon-ssm-agent | tee agent.log
#ssmstatus=$(egrep 'Active\:\sactive' agent.log | cut -d ' ' -f5)
#[ -n "$ssmstatus" ] && VALIDATION=false

# file existance
[ -f /etc/yum.repos.d/custom_RHEL6-system.repo ] || VALIDATION=false
[ -d /apps ] || VALIDATION=false
[ -d /logs ] || VALIDATION=false
[ -d /data ] || VALIDATION=false

# 3rd party packages
rpm -q CentrifyDC >/dev/null 2>&1 || VALIDATION=false
rpm -q AvamarClient >/dev/null 2>&1 || VALIDATION=false

if ! $VALIDATION ; then
  echo 'AMI validation failed'
  exit 1
fi

