provider "aws" {
  region = "us-east-1"
}



module "services" {
  source = "../modules/services"
}

module "network" {
  source = "../modules/network"
}

module "database" {
  source = "../modules/database"
}



