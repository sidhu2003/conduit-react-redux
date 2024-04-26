pipeline {

    agent any

    environment {
        registryUrl = 'programmer175/react-app'
        registryCredential = 'programmer175'
        dockerImage = ''
    }

    stages {

        stage('Install') {
            steps {
                sh 'npm install'
            }
        }

        stage('Unit Tests') {
            steps {
                sh 'npm test'
            }
        }

        stage('Static Code Analysis') {
            steps {
                sh 'npm run lint'
            }
        }

        stage('Build') {
            steps {
                script {
                   dockerImage = docker.build registryUrl + ":$BUILD_NUMBER"
                }
            }
        }

        stage('Push to Dockerhub') {
            steps {
                script {
                    docker.withRegistry( '', registryCredential ) {
                        dockerImage.push()
                        dockerImage.push("latest")
                    }
                }
            }
        }
        
    }
}