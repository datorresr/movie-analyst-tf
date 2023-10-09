provider "aws" {
  region = "us-east-1"
}



module "services" {
  source = "../modules/services"

}



