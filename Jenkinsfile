pipeline {
    agent any
    options{
        timestamps()
        ansiColor('xterm')
    }
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
		sshagent(['clave-sinensia']) {
                	sh 'git push --tags'
                }
                sh "docker tag ghcr.io/ripday18/hello-2048/hello-2048:latest ghcr.io/ripday18/hello-2048:1.0.${BUILD_NUMBER}"
            }
        }
        stage('Dockerlogin'){
           steps {
             withCredentials([string(credentialsId: 'github-token', variable: 'PAT')]) {
                 sh 'echo $PAT | docker login ghcr.io -u ripday18 --password-stdin && docker push ghcr.io/ripday18/hello-2048:1.0.${BUILD_NUMBER}'
            
             }

           }
        }
        stage('ConexionAWS'){
	   steps {
		sshagent(['ssh-amazon']) {
                   sh """
                      ssh -o "StrictHostKeyChecking no" ec2-user@34.245.57.52 'docker-compose pull && docker-compose up -d '
                   """
                }
           }
	}

    }
}
