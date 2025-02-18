packer {
  required_plugins {
    amazon = {
      source  = "github.com/hashicorp/amazon"
      version = ">= 1.0.0"
    }
  }
}

variable "aws_region" {
  type        = string
  default     = "us-east-1"
  description = "AWS region where the AMI will be built"
}

source "amazon-ebs" "docker_nginx" {
  ami_name      = "custom-nginx-ami-{{timestamp}}"
  instance_type = "t2.micro"
  region        = var.aws_region
  source_ami_filter {
    filters = {
      name                = "amzn2-ami-hvm-*-x86_64-gp2"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
    most_recent = true
    owners = ["amazon"]
  }

  ssh_username = "ec2-user"  # Required for Amazon Linux 2 AMI
}

build {
  sources = ["source.amazon-ebs.docker_nginx"]

  provisioner "shell" {
    inline = [
      # Update system packages
      "sudo yum update -y",

      # Install Docker
      "sudo amazon-linux-extras enable docker",
      "sudo yum install -y docker",
      "sudo systemctl enable docker",
      "sudo systemctl start docker",

      # Install Docker Compose
      "sudo curl -L \"https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)\" -o /usr/local/bin/docker-compose",
      "sudo chmod +x /usr/local/bin/docker-compose",

      # Install NGINX
      "sudo amazon-linux-extras enable nginx1",
      "sudo yum install -y nginx",
      "sudo systemctl enable nginx",
      "sudo systemctl start nginx",

      # Set up index.html with the server hostname
      "echo \"<h1>Server Hostname: $(hostname -f)</h1>\" | sudo tee /usr/share/nginx/html/index.html > /dev/null",

      # Restart NGINX to apply changes
      "sudo systemctl restart nginx",

      # Use full path to check NGINX installation
      "/usr/sbin/nginx -v",

      # Verify if the server is serving the index.html
      "curl -I http://localhost"
    ]
  }


}