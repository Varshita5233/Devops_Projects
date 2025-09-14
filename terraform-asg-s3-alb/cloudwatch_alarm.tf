# SNS Topic for notifications
resource "aws_sns_topic" "alerts" {
  name = "asg-alerts"
}

# SNS Subscription (Email)
resource "aws_sns_topic_subscription" "email_alert" {
  endpoint  = "damon.salvator2181@gmail.com"
  protocol  = "email"
  topic_arn = aws_sns_topic.alerts.arn
}

# CloudWatch Alarm for Scale OUT + SNS
resource "aws_cloudwatch_metric_alarm" "high_cpu" {
  alarm_name          = "HighCPUAlarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 120
  statistic           = "Average"
  threshold           = 80
  alarm_description   = "This metric monitors high ec2 cpu utilization"
  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.my_asg.name
  }
  alarm_actions = [aws_sns_topic.alerts.arn,aws_autoscaling_policy.scale_out.arn]
}

# CloudWatch Alarm for Scale IN + SNS
resource "aws_cloudwatch_metric_alarm" "low_cpu" {
  alarm_name          = "HighCPUAlarm"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 120
  statistic           = "Average"
  threshold           = 20
  alarm_description   = "This metric monitors low ec2 cpu utilization"
  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.my_asg.name
  }
  alarm_actions = [aws_sns_topic.alerts.arn,aws_autoscaling_policy.scale_in.arn]
}

# CloudWatch Dashboard for EC2 CPU
resource "aws_cloudwatch_dashboard" "infra_dashboard" {
  dashboard_name = "infra-dashboard"

  dashboard_body = jsonencode({
    widgets = [
      {
        type   = "metric"
        x      = 0
        y      = 0
        width  = 12
        height = 6

        properties = {
          metrics = [
            ["AWS/EC2", "CPUUtilization", "AutoScalingGroupName", aws_autoscaling_group.my_asg.name]
          ]
          period = 60
          stat   = "Average"
          region = "us-east-1"
          title  = "ASG CPU Utilization"
        }
      },
    ]
  })
}

