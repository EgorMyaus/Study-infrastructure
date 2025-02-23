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

variable "iam_role_name" {
  description = "IAM role name for EC2 instance"
  type        = string
  default     = "ec2-instance-role"
}

variable "iam_instance_profile_name" {
  description = "IAM instance profile name"
  type        = string
  default     = "ec2-instance-profile"
}

