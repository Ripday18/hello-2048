pipeline {
    agent any

    stages {
	stage('TestingDocker') {
            steps {
                sh 'docker-compose config'
            }
        }
        stage('building') {
            steps {
                sh 'docker-compose build'
                sh 'git tag 1.0.${BUILD_NUMBER}'
		sshagent(['ssh-amazon']) {
                	sh 'git push --tags'  
                }
                sh "docker tag ghcr.io/ripday18/hello-2048/hello-amazon:latest ghcr.io/ripday18/hello-amazon:1.0.${BUILD_NUMBER}"
        }
        stage('Dockerlogin'){
           steps {
             withCredentials([string(credentialsId: 'github-token', variable: 'PAT')]) {
                 sh 'echo $PAT | docker login ghcr.io -u ripday18 --password-stdin && docker push ghcr.io/ripday18/hello-2048/hello-2048:v1'
            
             }

           }
        }
        stage('ConexionAWS'){
	   steps {
		sshagent(['ssh-amazon']) {
                   sh """
                      ssh -o "StrictHostKeyChecking no" ec2-user@34.245.57.52 'docker pull ghcr.io/ripday18/hello-2048/hello-2048:v1 && docker run -td --rm -p 80:80 ghcr.io/ripday18/hello-2048/hello-2048:v1'
                   """
                }
           }
	}

    }
}
