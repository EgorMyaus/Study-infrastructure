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

data "aws_organizations_organization" "org" {}

module "ec2" {
  source        = "../modules/ec2"
  security_group_ids = [module.security.sg_id]  # Get security group ID from module
  key_pair_name = module.key_pair.key_pair_name  # Get key pair name from module
  iam_instance_profile_name = var.iam_instance_profile_name # Attach IAM Profile
  iam_role_name = var.iam_role_name  # Get IAM role name from module
}

module "key_pair" {
  source = "../modules/key_pair"
}

module "secrets" {
  source = "../modules/secrets"
}

module "security" {
  source = "../modules/security"
}