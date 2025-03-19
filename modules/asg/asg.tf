resource "aws_launch_template" "app_lt" {
  name_prefix   = "app-lt-"
  image_id      = var.ami_id
  instance_type = var.instance_type
  key_name      = var.key_name

  network_interfaces {
    security_groups = [var.ec2_sg_id]
    associate_public_ip_address = true
  }

  user_data = base64encode(<<EOF
#!/bin/bash
yum update -y
yum install -y httpd
systemctl start httpd
systemctl enable httpd
echo "Hello from $(hostname)" > /var/www/html/index.html
EOF
  )

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "app-instance"
    }
  }
}

resource "aws_autoscaling_group" "app_asg" {
  name                = "app-asg"
  min_size            = 0
  max_size            = 5
  desired_capacity    = 0
  vpc_zone_identifier = var.private_subnets
  target_group_arns = [var.target_group_arn]

  launch_template {
    id      = aws_launch_template.app_lt.id
    version = "$Latest"
  }

  health_check_type         = "EC2"
  health_check_grace_period = 300

  tag {
    key                 = "Name"
    value               = "app-instance"
    propagate_at_launch = true
  }
}

# Scale Out Policy (Adds instances when CPU > 70%)
resource "aws_autoscaling_policy" "scale_out" {
  name                   = "scale-out"
  scaling_adjustment     = 1  # Add 1 instance
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.app_asg.name
}

# Scale In Policy (Removes instances when CPU < 30%)
resource "aws_autoscaling_policy" "scale_in" {
  name                   = "scale-in"
  scaling_adjustment     = -1  # Remove 1 instance
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.app_asg.name
}

# Scheduled Scaling Action: Increase Instances at 06:00 UTC
resource "aws_autoscaling_schedule" "scale_up" {
  scheduled_action_name  = "ScaleUpMorning"
  autoscaling_group_name = aws_autoscaling_group.app_asg.name
  min_size              = 1
  desired_capacity      = 1
  max_size              = 5
  recurrence            = "0 6 * * *"  # At 06:00 UTC daily
}

# Scheduled Scaling Action: Decrease Instances at 22:00 UTC
resource "aws_autoscaling_schedule" "scale_down" {
  scheduled_action_name  = "ScaleDownNight"
  autoscaling_group_name = aws_autoscaling_group.app_asg.name
  min_size              = 0
  desired_capacity      = 0
  max_size              = 5
  recurrence            = "0 22 * * *"  # At 22:00 UTC daily
}

# CloudWatch Alarm for High CPU (Triggers Scale Out)
resource "aws_cloudwatch_metric_alarm" "high_cpu_alarm" {
  alarm_name          = "high-cpu-alarm"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace          = "AWS/EC2"
  period             = 60
  statistic          = "Average"
  threshold          = 70  # Trigger if CPU > 70%
  alarm_description  = "Alarm when CPU exceeds 70%"
  alarm_actions      = [aws_autoscaling_policy.scale_out.arn]  # Link to ASG policy
  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.app_asg.name
  }
}

# CloudWatch Alarm for Low CPU (Triggers Scale In)
resource "aws_cloudwatch_metric_alarm" "low_cpu_alarm" {
  alarm_name          = "low-cpu-alarm"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace          = "AWS/EC2"
  period             = 60
  statistic          = "Average"
  threshold          = 30  # Trigger if CPU < 30%
  alarm_description  = "Alarm when CPU drops below 30%"
  alarm_actions      = [aws_autoscaling_policy.scale_in.arn]  # Link to ASG policy
  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.app_asg.name
  }
}

