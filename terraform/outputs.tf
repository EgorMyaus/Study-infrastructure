output "account_name" {
  description = "The AWS account name retrieved from AWS Organizations."
  value       = data.aws_organizations_organization.org.master_account_name
}

output "alb_dns_name" {
  description = "DNS name of the ALB."
  value       = module.alb.alb_dns_name
}

output "asg_name" {
  description = "The name of the Auto Scaling Group."
  value       = module.asg.asg_name
}


