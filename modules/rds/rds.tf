resource "aws_db_instance" "myapp_db" {
  identifier           = var.rds_instance_id
  instance_class       = "db.t4g.micro"
  allocated_storage    = 20
  engine               = "mysql"
  engine_version       = "8.0.40"
  username             = "admin"
  password             = "StrongPass123!"
  publicly_accessible  = false
  storage_encrypted    = true
  multi_az             = false
  vpc_security_group_ids = [var.security_group]
  db_subnet_group_name = aws_db_subnet_group.myapp_subnet_group.name
  skip_final_snapshot  = true
}

resource "aws_db_subnet_group" "myapp_subnet_group" {
  name       = "myapp-db-subnet-group"
  subnet_ids = var.private_subnets

  tags = {
    Name = "myapp-db-subnet-group"
  }
}
