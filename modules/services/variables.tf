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

variable "subnet_ECS1_id" {
  description = "subnet_ECS1_id"
  type        = string
}

variable "subnet_ECS2_id" {
  description = "subnet_ECS2_id"
  type        = string
}

variable "subnet_LB1_id" {
  description = "subnet_LB1_id"
  type        = string
}

variable "subnet_LB2_id" {
  description = "subnet_LB2_id"
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


variable "SG_ECS_id" {
  description = "SG_ECS_id"
  type        = string
}
variable "SG_LB_id" {
  description = "SG_LB_EXT_FE_id"
  type        = string
}

variable "env" {
  description = "env"
  type        = string
}

variable "serv" {
  description = "serv"
  type        = string
}

variable "container" {
  description = "container"
  type        = string
}

variable "isInternal" {
  description = "ALB is Internal"
  type        = bool

}

variable "lb_port" {
  description = "lb_port"
  type        = string
}
variable "listener_port" {
  description = "listener_port"
  type        = string
}

variable "load_balancer_ip" {
  description = "load_balancer_ip"
  type        = string
}








