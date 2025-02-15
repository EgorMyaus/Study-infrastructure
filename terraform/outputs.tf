output "instance_public_ip" {
  description = "The public IP of the EC2 instance"
  value       = aws_instance.web_server_instance.public_ip
}

output "instance_id" {
  description = "The ID of the EC2 instance"
  value       = aws_instance.web_server_instance.id
}

output "my_test_secret_arn" {
  description = "The ARN of the stored secret"
  value       = aws_secretsmanager_secret.my_test_secret.arn
}

output "account_name" {
  description = "The AWS account name retrieved from AWS Organizations."
  value       = data.aws_organizations_organization.org.master_account_name
}


