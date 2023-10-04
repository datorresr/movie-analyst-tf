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
                sh 'terraform init'
            }
        }
        stage('Terraform apply') {
            steps {
                sh 'terraform ${action} --auto-approve'
            }
        }
        
    }
}