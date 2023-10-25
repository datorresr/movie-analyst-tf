pipeline {
    agent any

    stages {
        stage('Checkout') {
            steps {
                git credentialsId: 'githubcred', url: 'https://github.com/datorresr/movie-analyst-tf', branch: 'ECSBranch'
            }
        }
        stage('Terraform init') {
            steps {

                dir('/var/lib/jenkins/workspace/Movies_AWS_ECS_Dev_Inf/PreProd') {

                    sh 'terraform init'
                }
                
            }
        }
        stage('Terraform action') {
            steps {
                dir('/var/lib/jenkins/workspace/Movies_AWS_ECS_Dev_Inf/stage') {
                    sh 'export TF_LOG=DEBUG'
                    sh 'terraform ${action} --auto-approve -lock=false'
                }

            }
        }
        
    }
}