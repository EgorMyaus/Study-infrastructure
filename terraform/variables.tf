variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}

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

variable "ami_filter" {
  description = "Filter to get latest Amazon Linux 2 AMI"
  type = list(string)
  default = ["amzn2-ami-hvm-*-x86_64-gp2"]
}

variable "allowed_ssh_ip" {
  description = "Allowed SSH IP CIDR (modify for security)"
  type = list(string)
  default = ["94.63.118.183/32"]
}

variable "ec2_name" {
  description = "EC2 instance name"
  type        = string
  default     = "my-ec2-instance"
}

variable "key_name" {
  description = "Key pair name for SSH access"
  type        = string
  default     = "my-ec2-key"
}

variable "secret_name" {
  description = "Name of the AWS Secrets Manager secret"
  type        = string
  default     = "my-test-secret"
}



