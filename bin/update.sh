#!/bin/bash

source $1
printf "\033[34m ------------------------------------------------------------------------------------------------ \033[0m \n"

#validation
if [[ ${CLUSTER} == *"Select"* ]]; then
  echo "ERROR: Please select cluster name" 1>&2
  exit 1 # terminate and indicate error2
fi

echo "Routing the traffic to user specified version - ${VERSION}"

# Before - kubectl pod,service and deploymet status
/var/lib/jenkins/kubectl get svc -o wide --namespace=${ENVIRONMENT} --kubeconfig=${CLUSTER}

# Apply upgrade
printf "\033[34m ------------------------------------------------ apply upgrade ------------------------------------------------ \033[0m \n"
/var/lib/jenkins/kubectl apply -f ${APP_HOME}/kubernetes/ingress.yaml --namespace=${ENVIRONMENT} --kubeconfig=${CLUSTER}

#update the version in deployment file before execute
sed -i "s/tagver/${VERSION}/g" ${APP_HOME}/kubernetes/service.yaml
sed -i "s/environment/${ENVIRONMENT}/g" ${APP_HOME}/kubernetes/service.yaml

# apply update service, to point out pods with new application version
# you can use this command as well to change selector directly inplace of edit service file and apply
# "kubectl set selector service/hello-python-service owner=maplelabs,app=hello-python,env=mlpl,version=v23.0 -n mlpl"
/var/lib/jenkins/kubectl apply -f ${APP_HOME}/kubernetes/service.yaml --namespace=${ENVIRONMENT} --kubeconfig=${CLUSTER}

# After - kubectl pod,service and deploymet status
printf "\033[34m ------------------------------------------------ after: k8s stats ------------------------------------------------ \033[0m \n"
/var/lib/jenkins/kubectl get svc -o wide --namespace=${ENVIRONMENT} --kubeconfig=${CLUSTER}

helm upgrade hello-python-`echo ${VERSION} | tr . -` ${APP_HOME}/kubernetes/hello-python/ --values ${APP_HOME}/kubernetes/hello-python/values.yaml --set image.tag=${VERSION} --set ingress.enabled=false --set service.enabled=false --namespace=${ENVIRONMENT} --kubeconfig=${CLUSTER}

printf "\033[34m ------------------------------------------------ END ------------------------------------------------ \033[0m \n"