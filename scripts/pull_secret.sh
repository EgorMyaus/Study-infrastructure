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
