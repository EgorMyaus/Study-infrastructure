variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-east-1"
}

variable "aws_profile" {
  description = "AWS profile from ~/.aws/credentials"
  type        = string
  default     = "admin-cli-user"
}



