# DATA SOURCE: GET LATEST GET LATEST AMAZON LINUX 2 AMI
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners = ["amazon"]
  filter {
    name   = "name"
    values = var.ami_filter
  }
}

resource "aws_instance" "web_server_instance" {
  ami                         = data.aws_ami.amazon_linux.id
  instance_type               = var.instance_type
  associate_public_ip_address = true
  vpc_security_group_ids = [aws_security_group.web_server_sg.id]

  # Use key pair for EC2 instance
  key_name = aws_key_pair.my_key_pair.key_name

  # Read and execute scripts from the `scripts/` directory
  user_data = <<-EOF
                #!/bin/bash
                set -ex
                yum update -y

                # Install Docker
                amazon-linux-extras enable docker
                yum install -y docker
                systemctl enable docker
                systemctl start docker
                usermod -a -G docker ec2-user

                # Install Docker Compose (latest version)
                curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
                chmod +x /usr/local/bin/docker-compose

                docker --version
                docker-compose --version

                echo "Docker installed and docker-compose installed"
                EOF

  tags = {
    Name = var.ec2_name
  }
}