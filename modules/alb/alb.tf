resource "aws_lb" "app_alb" {
  name               = "app-alb"
  internal           = false # Set to true if the ALB is internal
  load_balancer_type = "application"
  security_groups = [var.alb_sg_id] # var.alb_sg_id is the output from the security module
  subnets            = var.public_subnets

  tags = {
    Name = "app-alb"
  }
}

resource "aws_lb_target_group" "app_tg" {
  name     = "app-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    path                = "/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  tags = {
    Name = "app-tg"
  }
}

//TODO add listener rule to forward traffic to target group for the ALB through HTTPS
/*resource "aws_lb_listener" "app_listener_https" {
  load_balancer_arn = aws_lb.app_alb.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = var.certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app_tg.arn
  }
}*/

resource "aws_lb_listener" "app_listener_http" {
  load_balancer_arn = aws_lb.app_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app_tg.arn
  }
}