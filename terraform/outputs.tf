output "account_name" {
  description = "The AWS account name retrieved from AWS Organizations."
  value       = data.aws_organizations_organization.org.master_account_name
}


