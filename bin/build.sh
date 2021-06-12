#!/bin/bash

source $1
# update version in main.py file for api response
sed -i "s/App version/App ${VERSION}/g" ${APP_HOME}/src/main.py

# Build Docker file
/bin/docker build -t iad.ocir.io/recvue/maplelabs/hello-python:${VERSION} ${APP_HOME}/.

# Login into OCIR
/bin/docker login iad.ocir.io --username="${OCIR_USER}" --password="${OCIR_PASSWORD}"

#Push image to OCIR
/bin/docker push iad.ocir.io/recvue/maplelabs/hello-python:${VERSION}
