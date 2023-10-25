variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

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

variable "rt_bastion" {
  description = "ID del route table BASTION"
  type        = string
  default     = "rtb-01642acfd18b1e169" 
}


variable "net_vpc" {
  description = "net vpc"
  type        = string
  default     = "10.20.0.0/16" 
}
