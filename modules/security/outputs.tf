output "sg_id" {
  description = "Security Group ID"
  value       = aws_security_group.web_server_sg.id
}