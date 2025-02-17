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