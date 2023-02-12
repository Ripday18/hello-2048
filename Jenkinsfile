pipeline {
    agent any
    stages {
        stage('Git Login'){
            steps {
                withCredentials([string(credentialsId: 'github-tokenqebyn', variable: 'PAT')]) {
                    sh 'echo $PAT | docker login ghcr.io -u qebyn --password-stdin'
                }
            }
        }
        stage('Image generation'){
            steps {
                sh 'docker-compose build'
                sh 'git tag -d 1.0.${BUILD_NUMBER}'
                sshagent(['github_access_ssh']) {
                    sh 'git push git@github.com:qebyn/hello-2048.git :refs/tags/1.0.${BUILD_NUMBER}'
                }
                sh 'git tag 1.1.${BUILD_NUMBER}'
                sshagent(['github_access_ssh']) {
                    sh 'git push git@github.com:qebyn/hello-2048.git --tags'
                }
                sh 'docker-compose push'
                sh 'VERSION_TAG=1.1.${BUILD_NUMBER} docker-compose push'
            }
        }
        stage('AWS deploy') {
            steps {
                sshagent(['ssh_amazon']) {
                    sh 'ssh ec2-user@3.253.61.205 docker pull ghcr.io/hello-2048/nginx2048:1.1.${BUILD_NUMBER}'
                    sh 'ssh ec2-user@3.253.61.205 docker run -dt --rm -p 80:80 ghcr.io/qebyn/hello-2048/nginx2048:1.1.${BUILD_NUMBER}'
                }
            }
        }
    }
}

