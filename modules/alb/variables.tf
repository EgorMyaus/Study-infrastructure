variable "vpc_id" {
  description = "The ID of the VPC where the ALB will be deployed."
  type        = string
}

variable "alb_sg_id" {
  description = "The security group ID to attach to the ALB."
  type        = string
}

variable "public_subnets" {
  description = "A list of public subnet IDs for the ALB."
  type        = list(string)
}