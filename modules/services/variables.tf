variable "VPCDevOpsRampUp" {
  description = "ID de la VPC VPCDevOpsRampUp"
  type        = string
  default     = "vpc-0014df68b2375fd8f" 
}

variable "SG_BASTION" {
  description = "ID del SG SG_BASTION"
  type        = string
  default     = "sg-0a5ba0c025cbf1f01" 
}

variable "IGW" {
  description = "ID del Internet Gateway IGW"
  type        = string
  default     = "igw-06bc140a6a7612779" 
}

variable "subnet_PriBE1_id" {
  description = "subnet_PriBE1_id"
  type        = string
}

variable "subnet_PriBE2_id" {
  description = "subnet_PriBE1_id"
  type        = string
}

variable "subnet_PriFE1_id" {
  description = "subnet_PriFE1_id"
  type        = string
}

variable "subnet_PriFE2_id" {
  description = "subnet_PriFE1_id"
  type        = string
}

variable "subnet_PubLB1_id" {
  description = "subnet_PubLB1_id"
  type        = string
}

variable "subnet_PubLB2_id" {
  description = "subnet_PubLB2_id"
  type        = string
}

variable "SG_BE_EC2_id" {
  description = "SG_BE_EC2_id"
  type        = string
}

variable "moviesDB_address" {
  description = "moviesDB_address"
  type        = string
  sensitive = true
}

variable "moviesDB_username" {
  description = "moviesDB_username"
  type        = string
  sensitive = true
}

variable "moviesDB_password" {
  description = "moviesDB_password"
  type        = string
  sensitive = true
}

variable "SG_LB_INT_BE_id" {
  description = "SG_LB_INT_BE_id"
  type        = string
}

variable "SG_FE_EC2_id" {
  description = "SG_FE_EC2_id"
  type        = string
}
variable "SG_LB_EXT_FE_id" {
  description = "SG_LB_EXT_FE_id"
  type        = string
}









