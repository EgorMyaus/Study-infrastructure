variable "ami_id" {
  description = "The AMI ID for the instances (built via Packer)."
  type        = string
}

variable "instance_type" {
  description = "The type of EC2 instance."
  type        = string
}

variable "key_name" {
  description = "The key pair to SSH into the instances."
  type        = string
}

variable "ec2_sg_id" {
  description = "The security group ID for EC2 instances."
  type        = string
}

variable "target_group_arn" {
  description = "The ARN of the ALB Target Group."
  type        = string
}

variable "private_subnets" {
  description = "A list of private subnets for ASG instances."
  type        = list(string)
}