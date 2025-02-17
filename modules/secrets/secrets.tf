# RESOURCE: Generate a Random Password
resource "random_password" "my_secret_password" {
  length  = 16
  special = true
  upper   = true
  lower   = true
  numeric = true
}

# AWS Secrets Manager Secret
resource "aws_secretsmanager_secret" "my_test_secret" {
  name        = var.secret_name
  description = "Randomly generated secret managed by Terraform"
}

# AWS Secrets Manager Secret Version (Stores the Random Password)
resource "aws_secretsmanager_secret_version" "my_test_secret_value" {
  secret_id     = aws_secretsmanager_secret.my_test_secret.id
  secret_string = jsonencode({
    username = "admin"
    password = random_password.my_secret_password.result
  })
}