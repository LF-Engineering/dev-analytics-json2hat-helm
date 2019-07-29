#!/bin/bash
if  [ -z "$1" ]
then
  echo "$0: you need to specify env: test, dev, stg, prod"
  exit 1
fi
"${1}h.sh" install json2hat-namespace ./json2hat-helm --set skipSecrets=1,skipCron=1
change_namespace.sh $1 json2hat
"${1}h.sh" install json2hat-secrets ./json2hat-helm --set "deployEnv=$1,skipCron=1,skipNamespace=1"
"${1}h.sh" install json2hat-cronjob ./json2hat-helm --set skipNamespace=1,skipSecrets=1
change_namespace.sh $1 default
