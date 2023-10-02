terraform {
  required_version = ">= 1.0.0, < 2.0.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

module "network" {
  source = "./network"
}

module "security" {
  source = "./security"
}

module "database" {
  source = "./database"
}

module "backend" {
  source = "./backend"
}

module "frontend" {
  source = "./frontend"
}
