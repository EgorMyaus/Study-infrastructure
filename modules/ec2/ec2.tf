data "aws_ami" "amazon_linux" {
  most_recent = true
  owners = ["amazon"]
  filter {
    name   = "name"
    values = var.ami_filter
  }
}

resource "aws_iam_instance_profile" "ec2_instance_profile" {
  name = var.iam_instance_profile_name
  role = var.iam_role_name
}

resource "aws_instance" "web_server_instance" {
  ami           = data.aws_ami.amazon_linux.id
  instance_type = var.instance_type
  associate_public_ip_address = true
  # Use security group from module input
  vpc_security_group_ids = var.security_group_ids

  # Use key pair from module input
  key_name = var.key_pair_name

  # Use IAM instance profile from module input
  iam_instance_profile = aws_iam_instance_profile.ec2_instance_profile.name

  user_data = <<-EOF
                #!/bin/bash
                set -ex

                # Update System Packages
                yum update -y

                # Install Docker
                yum install -y docker
                systemctl enable docker
                systemctl start docker
                usermod -aG docker ec2-user

                # Install Latest Docker Compose
                curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
                chmod +x /usr/local/bin/docker-compose

                docker --version
                docker-compose --version

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