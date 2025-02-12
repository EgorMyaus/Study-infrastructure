#!/bin/bash
set -ex

# Generate an SSH Key for EC2 User
sudo -u ec2-user ssh-keygen -t ed25519 -f /home/ec2-user/.ssh/id_ed25519 -q -N ""

# Store Public Key in AWS Systems Manager Parameter Store (SSM)
aws ssm put-parameter \
    --name "EC2-SSH-Public-Key" \
    --value "$(cat /home/ec2-user/.ssh/id_ed25519.pub)" \
    --type "String" \
    --overwrite \
    --region us-east-1

echo "SSH key generated and stored in AWS SSM."