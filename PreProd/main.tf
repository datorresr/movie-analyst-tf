provider "aws" {
  region = "us-east-1"
}

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
    key            = "ECS/PreProd/terraform.tfstate"
    region         = "us-east-1"

    # Replace this with your DynamoDB table name!
    dynamodb_table = "terraform-movieapp"
    encrypt        = true
  }
  
}

locals {
  environment    = "dev"
  service = "FE"
  net1 = "21"
  net2 = "22"
  net3 = "23"
  net4 = "24"
  net5 = "25"
  net6 = "26"
  container = ""
}



module "preprod_network" {
  source = "../modules/network"
  AZ_A = "us-east-1a"
  AZ_B = "us-east-1b"
  env = local.environment
  net1 = local.net1
  net2 = local.net2
  net3 = local.net3
  net4 = local.net4
  net5 = local.net5
  net6 = local.net6

}
module "preprod_database" {
  source = "../modules/database"
  env = local.environment
  subnet_PriBE1_id = module.preprod_network.subnet_PriBE1_id
  subnet_PriBE2_id = module.preprod_network.subnet_PriBE2_id
  SG_RDS_id = module.preprod_network.SG_RDS_id

}



module "preprod_BE" {
  source = "../modules/services"
  env = local.environment
  serv = "BE"
  container = "700029235138.dkr.ecr.us-east-1.amazonaws.com/movies-api:latest"
  isInternal = true
  lb_port = "3000"
  listener_port = "3000"

  subnet_ECS1_id = module.preprod_network.subnet_PriBE1_id
  subnet_ECS2_id = module.preprod_network.subnet_PriBE2_id
  subnet_LB1_id = module.preprod_network.subnet_PriBE1_id
  subnet_LB2_id = module.preprod_network.subnet_PriBE2_id
  SG_ECS_id = module.preprod_network.SG_BE_EC2_id
  SG_LB_id = module.preprod_network.SG_LB_INT_BE_id

  load_balancer_ip = ""

  moviesDB_address = module.preprod_database.moviesDB_address
  moviesDB_username = module.preprod_database.moviesDB_username
  moviesDB_password = module.preprod_database.moviesDB_password



  


}

module "preprod_FE" {
  source = "../modules/services"
  env = local.environment
  serv = "FE"
  container = "700029235138.dkr.ecr.us-east-1.amazonaws.com/movies-ui:latest"
  isInternal = false 
  lb_port = "80"
  listener_port = "3030"

  subnet_ECS1_id = module.preprod_network.subnet_PriBE1_id
  subnet_ECS2_id = module.preprod_network.subnet_PriBE2_id
  subnet_LB1_id = module.preprod_network.subnet_PubLB1_id
  subnet_LB2_id = module.preprod_network.subnet_PubLB2_id
  SG_ECS_id = module.preprod_network.SG_FE_EC2_id
  SG_LB_id = module.preprod_network.SG_LB_EXT_FE_id

  load_balancer_ip = module.preprod_BE.load_balancer_ip
  
  moviesDB_address = module.preprod_database.moviesDB_address
  moviesDB_username = module.preprod_database.moviesDB_username
  moviesDB_password = module.preprod_database.moviesDB_password

}



