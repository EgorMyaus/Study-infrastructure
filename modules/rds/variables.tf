variable "vpc_id" {
  description = "VPC ID for RDS"
  type        = string
}

variable "private_subnets" {
  description = "List of private subnets"
  type        = list(string)
}

variable "security_group" {
  description = "Security Group ID for RDS"
  type        = string
}

variable "rds_instance_id" {
  description = "RDS Instance Identifier"
  type        = string
}
