terraform {

  backend "s3" {
    # Replace this with your bucket name!
    bucket         = "terraform-state-movieapp"
    key            = "aws/kcluster/terraform.tfstate"
    region         = "us-east-1"

    # Replace this with your DynamoDB table name!
    dynamodb_table = "terraform-movieapp"
    encrypt        = true
  }


}