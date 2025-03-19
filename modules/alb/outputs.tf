output "alb_arn" {
  description = "The ARN of the ALB."
  value       = aws_lb.app_alb.arn
}

output "alb_dns_name" {
  description = "The DNS name of the ALB."
  value       = aws_lb.app_alb.dns_name
}

output "target_group_arn" {
  description = "The ARN of the target group."
  value       = aws_lb_target_group.app_tg.arn
}