pipeline  {
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
                        sh "docker container prune -f"
                        sh "docker image prune -a -f"
                        sh "docker builder prune --all --force"
                        sh "docker system prune"
                        sh "docker build -t react-app ."
                    }
                }
            }
        stage('Push to AWS ECR') {
            steps {
                script {
                    def awsCredentialsId = 'aws_creds'
                    withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', accessKeyVariable: 'AWS_ACCESS_KEY_ID', secretKeyVariable: 'AWS_SECRET_ACCESS_KEY', credentialsId: awsCredentialsId]]) {
                        sh 'aws ecr-public get-login-password --region us-east-1 | docker login --username AWS --password-stdin public.ecr.aws/t1v7e2d8'
                        sh "docker tag react-app public.ecr.aws/t1v7e2d8/react-application:latest"
                        sh "docker tag react-app public.ecr.aws/t1v7e2d8/react-application:${BUILD_NUMBER}"
                        sh "docker push public.ecr.aws/t1v7e2d8/react-application:latest"
                        sh "docker push public.ecr.aws/t1v7e2d8/react-application:${BUILD_NUMBER}"
                    }
                }
            }
        }
        stage ('Deploy to EKS'){
            steps{
                script {
                    def awsCredentialsId = 'aws_creds'
                    def kubeconfigFile = '/var/lib/jenkins/workspace/react-app/react-app-deployment/.kube/react_app_configfile'
                    withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', accessKeyVariable: 'AWS_ACCESS_KEY_ID', secretKeyVariable: 'AWS_SECRET_ACCESS_KEY', credentialsId: awsCredentialsId]]) {
                        sh "aws eks --region us-east-1 update-kubeconfig --name eks-react --kubeconfig ${kubeconfigFile}"
                        sh "helm upgrade --install ingress-nginx ingress-nginx --repo https://kubernetes.github.io/ingress-nginx --namespace ingress-nginx --create-namespace --kubeconfig ${kubeconfigFile}"
                        sh "helm upgrade --install react-app /var/lib/jenkins/workspace/react-app/react-app-deployment/react-app --kubeconfig ${kubeconfigFile} --set image.tag=${env.BUILD_NUMBER}"
                    }
                }
            }
        }
        
    }
}
