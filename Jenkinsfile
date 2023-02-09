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
                sh "docker tag ghcr.io/angelocho/hello-amazon/hello-amazon:latest ghcr.io/angelocho/hello-amazon:1.0.${BUILD_NUMBER}"
            }
        }
        stage('Dockerlogin'){
           steps {
             withCredentials([string(credentialsId: 'github-token', variable: 'PAT')]) {
                 sh 'echo $PAT | docker login ghcr.io -u angelocho --password-stdin && docker-compose push && docker push ghcr.io/angelocho/hello-amazon:1.0.${BUILD_NUMBER}'
            
             }

           }
        }
        stage('ConexionAWS'){
	   steps {
		sshagent(['ssh-amazon']) {
                   sh """
                      ssh -o "StrictHostKeyChecking no" ec2-user@ec2-34-244-177-29.eu-west-1.compute.amazonaws.com 'docker-compose pull && docker-compose up -d '
                   """
                }
           }
	}

    }
}
