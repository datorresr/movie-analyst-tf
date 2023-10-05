pipeline {
    agent any

    stages {
        stage('Checkout') {
            steps {
                git credentialsId: 'githubcred', url: 'https://github.com/datorresr/movie-analyst-tf'
            }
        }
        stage('Terraform init') {
            steps {
                sh 'cd stage'
                sh 'terraform init'
            }
        }
        stage('Terraform action') {
            steps {
                sh 'cd stage'
                sh 'terraform ${action} --auto-approve'
            }
        }
        
    }
}