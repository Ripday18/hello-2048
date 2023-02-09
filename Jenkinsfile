pipeline {
    agent any
    options {timestamps()}
	
    stages {
        stage('IMAGE'){
            steps{
                sh '''
                docker-compose build
                git tag 1.0.${BUILD_NUMBER}
                docker tag ghcr.io/ripday18/hello-2048/hello2048:v1 ghcr.io/ripday18/hello-2048/hello2048:1.0.${BUILD_NUMBER}
                '''
                sshagent(['GITHUB']) {
                    sh('git push git@github.com:ripday18/hello-2048.git --tags')
                }               
            }      
        }  
        
        stage('GIT_LOGIN'){
            steps{ 
		withCredentials([string(credentialsId: 'ghrc_token', variable: 'GIT_TOKEN')]){
		    sh 'echo $GIT_TOKEN | docker login ghcr.io -u ripday18 --password-stdin'
                    sh 'docker push ghcr.io/ripday18/hello-2048/hello2048:1.0.${BUILD_NUMBER}'
		}
            }
        }
      
        stage('SSH_AWS') {
            steps {
                withCredentials([sshUserPrivateKey(credentialsId:'github-token', keyFileVariable: 'AWS_SSH_KEY')]) {
			sh "ssh -i $AWS_SSH_KEY ec2-user@34.245.57.52 'mdkir app_hello-2048_${BUILD_NUMBER} && cd app_hello-2048_${BUILD_NUMBER} && touch docker-compose.yml && cat $dockerCompose > docker-compose.yml'"
			sh "ssh -i $AWS_SSH_KEY ec2-user@34.245.57.52 'docker pull ghcr.io/ripday18/hello-2048/hello2048:1.0.${BUILD_NUMBER} && docker-compose up -d'"
                }
            }
        }
    }     
}
