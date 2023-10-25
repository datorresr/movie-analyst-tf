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