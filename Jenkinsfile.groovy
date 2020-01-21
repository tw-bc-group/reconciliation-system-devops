pipeline {
    agent any
    stages {
        stage('Checkout') {
            steps {
                sh 'docker -v'
                sh 'docker-compose -v'
            }
        }

        stage('Prepare mock') {
            steps {
                sh 'docker build -t tw-blockchain/reconciliation-bridge-http-mock mock/bridge-http/'
                sh 'docker image tag tw-blockchain/reconciliation-bridge-http-mock localhost:5000/reconciliation-bridge-http-mock'
                sh 'docker push localhost:5000/reconciliation-bridge-http-mock'
            }
        }

        stage('Run Service') {
            steps {
                sh 'docker-compose up -d'
            }
        }
    }
}
