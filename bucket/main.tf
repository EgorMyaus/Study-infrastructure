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

module "s3" {
  source      = "../modules/s3"
  bucket_name = "cascais-terraform-state-bucket-5345"
}
