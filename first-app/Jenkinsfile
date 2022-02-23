pipeline {

  agent any

  options { timestamps () }

  environment {
    JENKINS_OCI='http://127.0.0.1:9002'
  }

  stages {

    stage ('build-app') {
      when {
        environment name: 'BUILD', value: 'true'
      }
      steps {
        build job: 'app-build-docker-image', parameters: [
          string(name: 'VERSION', value: "${env.VERSION}"),
          string(name: 'APPLICATION', value: "${env.APPLICATION}"),
          string(name: 'ENVIRONMENT', value: "${env.ENVIRONMENT}")
        ]
      }
    }

    stage ('deploy-app') {
      when {
        environment name: 'DEPLOY', value: 'true'
      }
      steps {
        build job: 'app-deploy-image-pod', parameters: [
          string(name: 'VERSION', value: "${env.VERSION}"),
          string(name: 'APPLICATION', value: "${env.APPLICATION}"),
          string(name: 'ENVIRONMENT', value: "${env.ENVIRONMENT}")
        ]
      }
    }

    stage ('test-app') {
      when {
        environment name: 'TEST', value: 'true'
      }
      steps {
        build job: 'app-test-running-pod', parameters: [
          string(name: 'VERSION', value: "${env.VERSION}"),
          string(name: 'APPLICATION', value: "${env.APPLICATION}"),
          string(name: 'ENVIRONMENT', value: "${env.ENVIRONMENT}")
        ]
      }
    }

    stage ('upgrade-version') {
      when {
        environment name: 'UPGRADE', value: 'true'
      }
      steps {
        build job: 'app-update-version', parameters: [
          string(name: 'VERSION', value: "${env.VERSION}"),
          string(name: 'APPLICATION', value: "${env.APPLICATION}"),
          string(name: 'ENVIRONMENT', value: "${env.ENVIRONMENT}")
        ]
      }
    }

  }
}
