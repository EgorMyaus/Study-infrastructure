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
  name                    = var.secret_name
  recovery_window_in_days = 0
  description             = "Randomly generated secret managed by Terraform"
}

# AWS Secrets Manager Secret Version (Stores the Random Password)
resource "aws_secretsmanager_secret_version" "my_test_secret_value" {
  secret_id = aws_secretsmanager_secret.my_test_secret.id
  secret_string = jsonencode({
    username = "admin"
    password = random_password.my_secret_password.result
  })
}

resource "aws_key_pair" "my_key_pair" {
  key_name = var.key_name
  public_key = file("~/.ssh/aws_ec2_ed25519.pub")
}

resource "aws_iam_policy" "secret_manager_policy" {
  name        = "secret_manager_access"
  description = "Allow EC2 instance to access Secrets Manager"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "secretsmanager:GetSecretValue",
          "secretsmanager:DescribeSecret",
          "secretsmanager:ListSecrets"
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role" "ec2_role" {
  name        = var.iam_role_name
  description = "Allow EC2 instance to assume role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "attach_secret_manager" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = aws_iam_policy.secret_manager_policy.arn
}

resource "aws_iam_instance_profile" "ec2_instance_profile" {
  name = var.iam_instance_profile_name
  role = var.iam_role_name
}

resource "aws_instance" "web_server_instance" {
  ami           = var.ami_id
  instance_type = var.instance_type
  associate_public_ip_address = true
  # Use security group from module input
  vpc_security_group_ids = var.security_group_ids

  # Use key pair from module input
  key_name = var.key_pair_name

  # Use IAM instance profile from module input
  iam_instance_profile = aws_iam_instance_profile.ec2_instance_profile.name

  subnet_id = var.subnet_id

  user_data = <<-EOF
                #!/bin/bash
                set -ex

                # Update the system
                yum update -y

                # Install AWS CLI and jq (for parsing JSON)
                yum install -y aws-cli jq

                # Fetch secret from AWS Secrets Manager and save it to .env
                SECRET_NAME="my-test-secret"  # Replace with actual secret name if needed
                AWS_REGION="us-east-1"        # Replace with your AWS region

                aws secretsmanager get-secret-value --secret-id $SECRET_NAME --region $AWS_REGION --query "SecretString" --output text > /home/ec2-user/.env

                echo "Secret pulled from Secrets Manager and stored in /home/ec2-user/.env"

                # Ensure proper file permissions
                chown ec2-user:ec2-user /home/ec2-user/.env
                chmod 600 /home/ec2-user/.env

                # Print contents for debugging (remove in production)
                cat /home/ec2-user/.env
                EOF

  tags = {
    Name = var.ec2_name
  }
}