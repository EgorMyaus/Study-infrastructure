variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
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
