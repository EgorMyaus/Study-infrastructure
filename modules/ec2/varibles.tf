variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}

variable "ami_id" {
  description = "The AMI ID for the instances (built via Packer)."
  type        = string
}

variable "ami_filter" {
  description = "Filter to get latest Amazon Linux 2 AMI"
  type = list(string)
  default = ["amzn2-ami-hvm-*-x86_64-gp2"]
}

variable "ec2_name" {
  description = "EC2 instance name"
  type        = string
  default     = "my-ec2-instance"
}

variable "security_group_ids" {
  description = "List of security groups to associate with the instance"
  type        = list(string)
}

variable "key_pair_name" {
  description = "Name of the SSH key pair"
  type        = string
}

variable "iam_instance_profile_name" {
  description = "IAM Instance Profile Name"
  type        = string
}

variable "iam_role_name" {
  description = "IAM role name for EC2 instance"
  type        = string
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

variable "subnet_id" {
  description = "Subnet ID where the EC2 instance will be launched"
  type        = string
}
