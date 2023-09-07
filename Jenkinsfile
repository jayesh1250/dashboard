pipeline {
    agent any

    stages {
        stage('Checkout Code') {
            steps {
                // Clone the GitHub repository
                git branch: 'main', url: 'https://github.com/jayesh1250/dashboard'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    def customImageTag = "react-app:${env.BUILD_NUMBER}"
                    docker.build(customImageTag, '-f Dockerfile .')
                }
            }
        }

        stage('Push to AWS ECR') {
            steps {
                script {
                    def awsAccountId = '318052783848'
                    def awsRegion = 'us-east-1'
                    def ecrRepo = 'public.ecr.aws/t1v7e2d8/react-application'

                    def customImageTag = "react-app:${env.BUILD_NUMBER}"
                    def ecrImageTag = "${awsAccountId}.dkr.ecr.${awsRegion}.amazonaws.com/${ecrRepo}:${env.BUILD_NUMBER}"

                    docker.withRegistry("https://${awsAccountId}.dkr.ecr.${awsRegion}.amazonaws.com", 'aws-ecr-credentials') {
                        docker.image(customImageTag).push(ecrImageTag)
                    }
                }
            }
        }

        stage('Deploy to AWS EKS') {
            steps {
                script {
                    def awsRegion = 'us-east-1'
                    def eksClusterName = 'eks-react'
                    def kubeconfigFile = "${JENKINS_HOME}/.kube/config"

                    // Configure kubectl to use the AWS EKS cluster
                    sh "aws eks --region ${awsRegion} update-kubeconfig --name ${eksClusterName} --kubeconfig ${kubeconfigFile}"

                    // Deploy Helm chart to the EKS cluster
                    sh "helm upgrade --install my-app ./helm-chart --kubeconfig ${kubeconfigFile} --namespace my-namespace --set image.tag=${env.BUILD_NUMBER}"
                }
            }
        }
    }
}
