
# Infrastructure as Code
- cd packer
- packer build -var-file=variables.pkrvars.hcl docker-nginx.pkr.hcl

# terraform
- cd terraform
- terraform init 
- terraform plan 
- terraform apply

# ssh
ssh -i ~/.ssh/aws_ec2_ed25519 ec2-user@54.152.23.38


# troubleshooting
- terraform import module.ec2.aws_iam_instance_profile.ec2_instance_profile ec2-instance-profile
- aws secretsmanager delete-secret --secret-id my-test-secret --force-delete-without-recovery