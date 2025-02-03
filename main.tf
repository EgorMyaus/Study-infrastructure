# PROVIDER CONFIGURATION
provider "aws" {
  region = "us-east-1"
  # use profile for my aws account from ~/.aws/credentials
  profile = "admin-cli-user"
}

# DATA SOURCE: GET LATEST GET LATEST AMAZON LINUX 2 AMI
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners = ["amazon"]
  filter {
    name = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

# RESOURCE: AWS KEY_PAIR
resource "aws_key_pair" "my_key_pair" {
  key_name = "my-ec2-key"
  public_key = file("~/.ssh/aws_ec2_ed25519.pub")
}

# RESOURCE: CREATE SECURITY GROUP
resource "aws_security_group" "my_security_group" {
  name        = "my-security-group"
  description = "Allow inbound traffic on port 22, 80, 443"

  # to allow SSH from any IP (not recommended for security reasons),
  # change to cidr_blocks = ["0.0.0.0/0"]
  # Ingress controls incoming traffic (who can access your instance)
  # Egress controls outgoing traffic (where your instance can connect)
  # AWS blocks all ingress traffic by default, so you must define security rules
  # In AWS security groups, cidr_blocks defines which IP addresses or
  # IP ranges can access your EC2 instance over a specific port
  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"
    cidr_blocks = ["94.63.118.183/32"]
  }

  ingress {
    from_port = 80
    to_port   = 80
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 443
    to_port   = 443
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port   = 0
    protocol = "-1"   # Allows all protocols
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# RESOURCE: CREATE EC2 INSTANCE
resource "aws_instance" "my_ec2_instance" {
  ami           = data.aws_ami.amazon_linux.id
  instance_type = "t2.micro"
  associate_public_ip_address = true

  # use security group for my ec2 instance
  vpc_security_group_ids = [aws_security_group.my_security_group.id]

  # use key pair for my ec2 instance
  key_name = aws_key_pair.my_key_pair.key_name

  # install docker and docker-compose on my ec2 instance
  user_data = <<-EOF
                #!/bin/bash
                yum update -y
                amazon-linux-extras install docker -y
                systemctl enable docker
                systemctl start docker
                usermod -a -G docker ec2-user

                # Install Docker Compose (example version 1.29.2)
                curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
                chmod +x /usr/local/bin/docker-compose
                docker --version
                docker-compose --version
                EOF

  tags = {
    Name = "my-ec2-instance"
  }
}

# Output: Display the EC2 instance's public IP after deployment
output "instance_public_ip" {
  description = "The public IP of the EC2 instance"
  value       = aws_instance.my_ec2_instance.public_ip
}