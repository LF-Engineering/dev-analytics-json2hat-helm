#!/bin/bash
if  [ -z "$1" ]
then
  echo "$0: you need to specify env: test, dev, stg, prod"
  exit 1
fi
"${1}h.sh" install json2hat-namespace ./json2hat-helm --set skipSecrets=1,skipCron=1
change_namespace.sh $1 json2hat
change_namespace.sh $1 default
