output "subnet_PriBE1_id" {
  value = aws_subnet.PriBE1.id
}
output "subnet_PriBE2_id" {
  value = aws_subnet.PriBE2.id
}
output "subnet_PriFE1_id" {
  value = aws_subnet.PriFE1.id
}
output "subnet_PriFE2_id" {
  value = aws_subnet.PriFE2.id
}
output "subnet_PubLB1_id" {
  value = aws_subnet.PubLB1.id
}
output "subnet_PubLB2_id" {
  value = aws_subnet.PubLB2.id
}

output "SG_RDS_id" {
  value = aws_security_group.SG_RDS.id
}
output "SG_FE_EC2_id" {
  value = aws_security_group.SG_FE_EC2.id
}
output "SG_BE_EC2_id" {
  value = aws_security_group.SG_BE_EC2.id
}
output "SG_LB_INT_BE_id" {
  value = aws_security_group.SG_LB_INT_BE.id
}
output "SG_LB_EXT_FE_id" {
  value = aws_security_group.SG_LB_EXT_FE.id
}
