#!/bin/bash
source $1

# Before - kubectl pod,service and deploymet status
kubectl get po -o wide --namespace=${ENVIRONMENT}

# apply deployment
printf "\033[34m ------------------------------------------------ apply deployment ------------------------------------------------ \033[0m \n"
exit_code=0

#/var/lib/jenkins/kubectl apply -f ${APP_HOME}/kubernetes/deployment.yaml --namespace=${ENVIRONMENT} --kubeconfig=${CLUSTER}
helm install hello-python-`echo ${VERSION} | tr . -` ${APP_HOME}/kubernetes/hello-python/ --values ${APP_HOME}/kubernetes/hello-python/values.yaml --set image.tag=${VERSION} --namespace=${ENVIRONMENT} -o=json > bin/deploy.json

# call Python function :
if [ $? -eq 0 ]
then
  echo "Command executed successfully."
  cd bin
  deploy=$(python -c 'import sys; sys.path.append(sys.argv[1]); import script; script.get_pods_data(sys.argv[2], sys.argv[3])' "${utils_path}" "${ENVIRONMENT}" "${CLUSTER}")
  if [ $? -eq 0 ]
  then
    echo "Python script executed successfully."
  else
    echo "Python script exited with exit code 1."
    exit_code=1
  fi
  echo "$deploy"
else
  echo "Error occurred while running the command."
  exit_code=1
fi

# After - kubectl pod,service and deploymet status
printf "\033[34m ------------------------------------------------ after: k8s stats ------------------------------------------------ \033[0m \n"
kubectl get po -o wide --namespace=${ENVIRONMENT}

if [ "$exit_code" -eq 1 ]; then
  exit 1
fi

printf "\033[34m ------------------------------------------------ END ------------------------------------------------ \033[0m \n"
