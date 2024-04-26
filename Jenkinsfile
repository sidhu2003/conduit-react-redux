pipeline {

    agent any

    environment {
        registryUrl = 'programmer175/react-app'
        registryCredential = 'programmer175'
        dockerImage = ''
    }

    stages {

        stage('Initialize') {
            steps {
                sh 'npm install'
            }
        }

        stage('Unit Testing') {
            steps {
                sh 'npm test'
            }
        }

        stage('Static Code Analysis') {
            steps {
                sh 'npm run lint'
            }
        }

        stage('Build Image') {
            steps {
                script {
                   dockerImage = docker.build registryUrl + ":$BUILD_NUMBER"
                }
            }
        }

        stage('Image Vulnerability Scan') {
            steps {
                script {
                    sh """trivy image --format template --template \"~/home/templates/html.tpl\" --output trivy_report.html ${registryUrl}:${BUILD_NUMBER}"""
                    
                }
            }
        }

        stage('Push to Dockerhub Registry') {
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
    post {
        always {
            archiveArtifacts artifacts: "trivy_report.html", fingerprint: true
            publishHTML (target: [
                allowMissing: false,
                alwaysLinkToLastBuild: false,
                keepAll: true,
                reportDir: '.',
                reportFiles: 'trivy_report.html',
                reportName: 'Trivy Scan',
                ])
            }
        }
}