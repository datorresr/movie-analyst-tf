provider "aws" {
  region = "us-east-1"
}
module "stage_network" {
  source = "../modules/network"
  AZ_A = "us-east-1a"
  AZ_B = "us-east-1b"

}
module "stage_database" {
  source = "../modules/database"
  subnet_PriBE1_id = module.stage_network.subnet_PriBE1_id
  subnet_PriBE2_id = module.stage_network.subnet_PriBE2_id
  SG_RDS_id = module.stage_network.SG_RDS_id

}
module "stage_services" {
  source = "../modules/services"
  subnet_PriBE1_id = module.stage_network.subnet_PriBE1_id
  subnet_PriBE2_id = module.stage_network.subnet_PriBE2_id
  subnet_PriFE1_id = module.stage_network.subnet_PriFE1_id
  subnet_PriFE2_id = module.stage_network.subnet_PriFE2_id
  subnet_PubLB1_id = module.stage_network.subnet_PubLB1_id
  subnet_PubLB2_id = module.stage_network.subnet_PubLB2_id
  moviesDB_address = module.stage_database.moviesDB_address
  moviesDB_username = module.stage_database.moviesDB_username
  moviesDB_password = module.stage_database.moviesDB_password
  SG_BE_EC2_id = module.stage_network.SG_BE_EC2_id
  SG_FE_EC2_id = module.stage_network.SG_FE_EC2_id
  SG_LB_INT_BE_id = module.stage_network.SG_LB_INT_BE_id
  SG_LB_EXT_FE_id = module.stage_network.SG_LB_EXT_FE_id

}


