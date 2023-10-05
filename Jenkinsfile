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

                dir('/var/lib/jenkins/workspace/MoviesTF/stage') {

                    sh 'terraform init'
                }
                
            }
        }
        stage('Terraform action') {
            steps {
                dir('/var/lib/jenkins/workspace/MoviesTF/stage') {
                    sh 'terraform ${action} --auto-approve -lock=false'
                }

            }
        }
        
    }
}