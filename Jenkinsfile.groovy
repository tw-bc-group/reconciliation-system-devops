pipeline {
    agent any
    stages {
        stage('Checkout') {
            steps {
                sh 'docker -v'
            }
        }
    }
}
