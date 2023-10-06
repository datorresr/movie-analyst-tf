provider "aws" {
  region = "us-east-1"
}

module "network" {
  source = "./modules/network"

}

module "database" {
  source = "./modules/database"

}

module "services" {
  source = "./modules/services"

}



