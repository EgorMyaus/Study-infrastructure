output "my_test_secret_arn" {
  description = "The ARN of the stored secret"
  value       = aws_secretsmanager_secret.my_test_secret.arn
}