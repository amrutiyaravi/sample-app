#!/bin/bash

source $1
printf "\033[34m ------------------------------------------------------------------------------------------------ \033[0m \n"

# Before - kubectl pod,service and deploymet status
kubectl get svc -o wide --namespace=${ENVIRONMENT} --kubeconfig=${CLUSTER}

# Apply upgrade
printf "\033[34m ------------------------------------------------ apply upgrade ------------------------------------------------ \033[0m \n"
kubectl apply -f ${APP_HOME}/kubernetes/ingress.yaml --namespace=${ENVIRONMENT}

#update the version in deployment file before execute
sed -i "s/tagver/${VERSION}/g" ${APP_HOME}/kubernetes/service.yaml
sed -i "s/environment/${ENVIRONMENT}/g" ${APP_HOME}/kubernetes/service.yaml

kubectl apply -f ${APP_HOME}/kubernetes/service.yaml --namespace=${ENVIRONMENT}

# After - kubectl pod,service and deploymet status
printf "\033[34m ------------------------------------------------ after: k8s stats ------------------------------------------------ \033[0m \n"
kubectl get svc -o wide --namespace=${ENVIRONMENT}

helm upgrade hello-python-`echo ${VERSION} | tr . -` ${APP_HOME}/kubernetes/hello-python/ --values ${APP_HOME}/kubernetes/hello-python/values.yaml --set image.tag=${VERSION} --set ingress.enabled=false --set service.enabled=false --namespace=${ENVIRONMENT}
printf "\033[34m ------------------------------------------------ END ------------------------------------------------ \033[0m \n"