pipeline {
    agent any

    stages {
        stage('clone') {
            steps {
                git branch: 'main', url: 'https://github.com/Ripday18/hello-2048.git'
            }
        }
        stage('Build') {
            steps {
                sh 'docker-compose build'
            }
        }
        stage('Deploy') {
            steps {
                sh 'docker-compose up -d'
            }
        }
    
    }
}
