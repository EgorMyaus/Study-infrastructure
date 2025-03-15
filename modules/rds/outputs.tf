output "rds_endpoint" {
  description = "RDS endpoint"
  value       = aws_db_instance.myapp_db.endpoint
}

output "rds_instance_id" {
  description = "RDS Instance Identifier"
  value       = aws_db_instance.myapp_db.id
}
