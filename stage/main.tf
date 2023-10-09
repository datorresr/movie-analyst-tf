provider "aws" {
  region = "us-east-1"
}



module "stage_services" {
  source = "../modules/services"
}

module "stage_network" {
  source = "../modules/network"
}

module "stage_database" {
  source = "../modules/database"
}



