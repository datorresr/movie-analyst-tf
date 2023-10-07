output "subnet_PriBE1_id" {
  value = module.network.subnet_PriBE1_id
}
output "subnet_PriBE2_id" {
  value = module.network.subnet_PriBE2_id
}
output "subnet_PriFE1_id" {
  value = module.network.subnet_PriFE1_id
}
output "subnet_PriFE2_id" {
  value = module.network.subnet_PriFE2_id
}
output "subnet_PubLB1_id" {
  value = module.network.subnet_PubLB1_id
}
output "subnet_PubLB2_id" {
  value = module.network.subnet_PubLB2_id
}

output "SG_RDS_id" {
  value = module.network.SG_RDS_id
}
output "SG_FE_EC2_id" {
  value = module.network.SG_FE_EC2_id
}
output "SG_BE_EC2_id" {
  value = module.network.SG_BE_EC2_id
}
output "SG_LB_INT_BE_id" {
  value = module.network.SG_LB_INT_BE_id
}
output "SG_LB_EXT_FE_id" {
  value = module.network.SG_LB_EXT_FE_id
}



output "moviesDB_address" {
  value = module.database.moviesDB_address
  sensitive = true
}
output "moviesDB_username" {
  value = module.database.moviesDB_username
  sensitive = true
}
output "moviesDB_password" {
  value = module.database.moviesDB_password
  sensitive = true
}

