output "instance_public_ip" {
  description = "The public IP of the EC2 instance"
  value       = aws_instance.web_server_instance.public_ip
}

output "instance_id" {
  description = "The ID of the EC2 instance"
  value       = aws_instance.web_server_instance.id
}

output "key_pair_name" {
  description = "Name of the key pair"
  value       = aws_key_pair.my_key_pair.key_name
}

output "my_test_secret_arn" {
  description = "The ARN of the stored secret"
  value       = aws_secretsmanager_secret.my_test_secret.arn
}