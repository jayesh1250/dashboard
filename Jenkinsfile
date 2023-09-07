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
                    sh "docker build -t react-app ."
                }
            }
        }
    
    }
}
