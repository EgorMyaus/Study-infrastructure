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

data "aws_ami" "packer_ami" {
  most_recent = true
  owners      = ["self"] # Only look for AMIs in your account
  filter {
    name   = "name"
    values = ["custom-nginx-ami-*"] # Match AMI built by Packer
  }
}

module "vpc" {
  source = "../modules/vpc"
}

module "ec2" {
  source                    = "../modules/ec2"
  ami_id                    = data.aws_ami.packer_ami.id
  subnet_id                 = module.vpc.public_subnets[0] # First private subnet
  security_group_ids        = [module.security.ec2_sg_id]   # Get ec2 security group ID from module
  key_pair_name             = module.ec2.key_pair_name      # Get key pair name from module
  iam_instance_profile_name = var.iam_instance_profile_name # Attach IAM Profile
  iam_role_name             = var.iam_role_name             # Get IAM role name from module
}

module "security" {
  source = "../modules/security"
  vpc_id = module.vpc.vpc_id
}

module "alb" {
  source         = "../modules/alb"
  vpc_id         = module.vpc.vpc_id
  alb_sg_id      = module.security.alb_sg_id
  public_subnets = module.vpc.private_subnets
}

module "asg" {
  source           = "../modules/asg"
  ami_id           = data.aws_ami.packer_ami.id
  instance_type    = var.instance_type
  key_name         = module.ec2.key_pair_name
  ec2_sg_id        = module.security.ec2_sg_id
  target_group_arn = module.alb.target_group_arn
  private_subnets  = module.vpc.private_subnets
}

terraform {
  backend "s3" {
    bucket         = "cascais-terraform-state-bucket-5345"
    key            = "study-infrastructure/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
  }
}