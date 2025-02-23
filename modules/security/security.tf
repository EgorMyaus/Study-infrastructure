resource "aws_security_group" "web_server_sg" {
  name        = "web_server_sg"
  description = "Allow inbound traffic on port 22, 80, 443"

  # to allow SSH from any IP (not recommended for security reasons),
  # change to cidr_blocks = ["0.0.0.0/0"]
  # Ingress controls incoming traffic (who can access your instance)
  # Egress controls outgoing traffic (where your instance can connect)
  # AWS blocks all ingress traffic by default, so you must define security rules
  # In AWS security groups, cidr_blocks defines which IP addresses or
  # IP ranges can access your EC2 instance over a specific port
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.allowed_ssh_ip
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}