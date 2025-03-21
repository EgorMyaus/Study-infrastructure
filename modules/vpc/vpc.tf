resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = { Name = "main-vpc" }
}

# Public Subnets
resource "aws_subnet" "public_1" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true
  tags = { Name = "public-subnet-1" }
}

resource "aws_subnet" "public_2" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = true
  tags = { Name = "public-subnet-2" }
}

# Private Subnets
resource "aws_subnet" "private_1" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.3.0/24"
  availability_zone = "us-east-1a"
  tags = { Name = "private-subnet-1" }
}

resource "aws_subnet" "private_2" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.4.0/24"
  availability_zone = "us-east-1b"
  tags = { Name = "private-subnet-2" }
}

# Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
  tags   = { Name = "main-igw" }
}

# Route Table for Public Subnets
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = { Name = "public-route-table" }
}

resource "aws_route_table_association" "public_1" {
  subnet_id      = aws_subnet.public_1.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public_2" {
  subnet_id      = aws_subnet.public_2.id
  route_table_id = aws_route_table.public.id
}

# Elastic IP for NAT Gateway
resource "aws_eip" "nat" {
  domain = "vpc"
}

# NAT Gateway for Private Subnets
resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public_1.id
  tags          = { Name = "main-nat-gateway" }
}

# Route Table for Private Subnets (Traffic to NAT Gateway)
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat.id
  }

  tags = { Name = "private-route-table" }
}

resource "aws_route_table_association" "private_1" {
  subnet_id      = aws_subnet.private_1.id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "private_2" {
  subnet_id      = aws_subnet.private_2.id
  route_table_id = aws_route_table.private.id
}

# Network ACL for Public & Private Subnets
resource "aws_network_acl" "main_acl" {
  vpc_id = aws_vpc.main.id

  # ✅ Allow HTTP (80), HTTPS (443), and SSH (22)
  ingress {
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    protocol   = "tcp"
    from_port  = 80
    to_port    = 80
  }

  ingress {
    rule_no    = 110
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    protocol   = "tcp"
    from_port  = 443
    to_port    = 443
  }

  ingress {
    rule_no    = 120
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    protocol   = "tcp"
    from_port  = 22
    to_port    = 22
  }

  # ✅ Allow return traffic on ephemeral ports (1024-65535)
  ingress {
    rule_no    = 130
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    protocol   = "tcp"
    from_port  = 1024
    to_port    = 65535
  }

  # ✅ Allow all outbound traffic
  egress {
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    protocol   = "-1"
    from_port  = 0
    to_port    = 0
  }

  tags = { Name = "main-acl" }
}

# Associate NACL with Public & Private Subnets
resource "aws_network_acl_association" "public_1_acl" {
  network_acl_id = aws_network_acl.main_acl.id
  subnet_id      = aws_subnet.public_1.id
}

resource "aws_network_acl_association" "public_2_acl" {
  network_acl_id = aws_network_acl.main_acl.id
  subnet_id      = aws_subnet.public_2.id
}

resource "aws_network_acl_association" "private_1_acl" {
  network_acl_id = aws_network_acl.main_acl.id
  subnet_id      = aws_subnet.private_1.id
}

resource "aws_network_acl_association" "private_2_acl" {
  network_acl_id = aws_network_acl.main_acl.id
  subnet_id      = aws_subnet.private_2.id
}
