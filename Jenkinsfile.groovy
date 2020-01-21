pipeline {
    agent none
    stages {
        stage {
            agent { node("${compiler}") }
            steps {
                sh 'docker -v'
            }
        }
    }
}