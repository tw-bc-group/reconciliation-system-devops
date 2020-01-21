pipeline {
    agent none
    stages {
      agent { node("${compiler}") }
      steps {
        sh 'docker -v'
      }
    }
}