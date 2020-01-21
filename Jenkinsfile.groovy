pipeline {
    agent any
    stages {
        stage('Checkout') {
            steps {
                sh 'docker -v'
                sh 'docker-compose -v'
            }
        }

        stage('Run Service') {
            steps {
                sh 'docker-compose up -d'
            }
        }
    }
}
