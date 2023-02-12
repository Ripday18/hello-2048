pipeline {
    agent any

    stages {
	stage('Git Login'){
	    steps {
		withCredentials([string(credentialsId: 'github-token', variable: 'PAT')]) {
		    sh 'echo $GIT_TOKEN | docker login ghcr.io -u qebyn --password-stdin'
		}
	    }
	}
        stage('Image generation'){
            steps {
		sh 'docker-compose build'
                sh 'VERSION_TAG=1.0.${BUILD_NUMBER} docker-compose build'
		sh 'git tag 1.0.${BUILD_NUMBER}'
		sshagent(['github-ssh']) {
		    sh 'git push git@github.com:qebyn/hello-2048.git --tags'
		}
		sh 'docker-compose push'
                sh 'VERSION_TAG=1.0.${BUILD_NUMBER} docker-compose push'
            }
        }
        stage('AWS deploy') {
            steps {
                sshagent(['ssh_amazon']) {
		    sh 'ssh ec2-user@ec2-3-253-61-205 docker pull ghcr.io/qebyn/hello-2048/hello-2048:1.0.${BUILD_NUMBER}'
                    sh 'ssh ec2-user@3.250.172.231 docker run -dt --rm -p 80:80 ghcr.io/qebyn/hello-2048/hello-2048:1.0.${BUILD_NUMBER}'
                }
            }
        }
    }
}
