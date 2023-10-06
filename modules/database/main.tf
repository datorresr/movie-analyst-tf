terraform {
  required_version = ">= 1.0.0, < 2.0.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }

  backend "s3" {
    # Replace this with your bucket name!
    bucket         = "terraform-state-movieapp"
    key            = "stage/database/terraform.tfstate"
    region         = "us-east-1"

    # Replace this with your DynamoDB table name!
    dynamodb_table = "terraform-movieapp"
    encrypt        = true
  }
  
}




data "terraform_remote_state" "net" {
  backend = "s3"

  config = {
    bucket = "terraform-state-movieapp"
    key    = "stage/network/terraform.tfstate"
    region = "us-east-1"
  }
}