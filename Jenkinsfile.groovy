pipeline {
    agent none
    stages {
        stage('Checkout') {
            agent { node("${compiler}") }
            steps {
                sh 'docker -v'
            }
        }
    }
}
