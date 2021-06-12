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
        build job: 'bg-build-app-docker-image', parameters: [
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
        build job: 'bg-deploy-app-pods', parameters: [
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
        build job: 'bg-run-test-plan', parameters: [
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
        build job: 'bg-update-version', parameters: [
          string(name: 'VERSION', value: "${env.VERSION}"),
          string(name: 'APPLICATION', value: "${env.APPLICATION}"),
          string(name: 'ENVIRONMENT', value: "${env.ENVIRONMENT}")
        ]
      }
    }

  }
}
