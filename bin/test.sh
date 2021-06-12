#!/bin/bash
source $1

#validation
if [[ ${CLUSTER} == *"Select"* ]]; then
  echo "ERROR: Please select cluster name" 1>&2
  exit 1 # terminate and indicate error2
fi

echo "Executing Link Checker Script ..."

rm -rf ${APP_HOME}/src/RECVUE_Sanity
git clone --branch MergeOther https://${Recvue_DevOps_user}:${Recvue_DevOps_password}@github.com/InfovityInc/RECVUE_Sanity.git ${APP_HOME}/src/RECVUE_Sanity

cd ${APP_HOME}/src/RECVUE_Sanity
mvn clean test

if [ $? -eq 1 ]; then
  exit 1
fi

printf "\033[34m ------------------------------------------------------------------------------------------------ \033[0m \n"
