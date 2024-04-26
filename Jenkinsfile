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
                    sh """trivy image --format template --template "@/usr/bin/html.tpl" --output trivy_report.html ${registryUrl}:${BUILD_NUMBER}"""
                    
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

        stage('Deploy to Amazon ECS Cluster'){
        steps {
            withAWS(region: 'us-east-1',credentials: 'jenkins-aws') {
                script {
                   sh 'aws ecs update-service --cluster ${cluster} --service ${service} --force-new-deployment'
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