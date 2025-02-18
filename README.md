cd packer
- packer build -var-file=variables.pkrvars.hcl docker-nginx.pkr.hcl

cd terraform
- terraform init 
- terraform plan 
- terraform apply


# troubleshooting
- terraform import module.ec2.aws_iam_instance_profile.ec2_instance_profile ec2-instance-profile
- aws secretsmanager delete-secret --secret-id my-test-secret --force-delete-without-recovery