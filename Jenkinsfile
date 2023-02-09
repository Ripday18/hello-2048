pipeline {
    agent any
    stages {
        stage('Build') {
            steps {
                sh 'docker-compose build'
                sh "git tag 1.0.${BUILD_NUMBER}" 
                sh "docker tag ghcr.io/ripday18/hello-2048:latest ghcr.io/ripday18/hello-2048:1.0.${BUILD_NUMBER}" 
                sshagent(['github-token']) {
                    sh "git push --tags"
                }
                
            }
        }
         stage('Package'){
             steps{
                withCredentials([string(credentialsId: 'github-token', variable: 'PAT')]) {
                    sh "echo $PAT | docker login ghcr.io -u ripday18 --password-stdin"
                    sh 'docker-compose push'
                    sh "docker push ghcr.io/ripday18/hello-2048:1.0.${BUILD_NUMBER}"
                }
            }
        }
        stage('Deploy') {
            steps {            
                sshagent(['ssh-amazon']) {
                    sh 'ssh -o "StrictHostKeyChecking no" ec2-user@34.245.57.52 docker pull ghcr.io/ripday18/hello-2048:1.0.${BUILD_NUMBER}'
                    sh """ssh ec2-user@34.245.57.52 docker-compose up -d"""
                }
            }
        }
    }
}

