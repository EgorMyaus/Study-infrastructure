terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.81.0"
    }
  }
}

provider "aws" {
  region  = var.aws_region
  profile = var.aws_profile
}

module "vpc" {
  source = "../modules/vpc"
}

module "security" {
  source = "../modules/security"
  vpc_id = module.vpc.vpc_id
}

module "rds" {
  source          = "../modules/rds"
  vpc_id          = module.vpc.vpc_id
  private_subnets = module.vpc.private_subnets
  security_group  = module.security.rds_sg
  rds_instance_id = "my-db-instanse"
}