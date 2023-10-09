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

variable "AZ_A" {
  description = "AZ_A"
  type        = string
}

variable "AZ_B" {
  description = "AZ_B"
  type        = string
}





