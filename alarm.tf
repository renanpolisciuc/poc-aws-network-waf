resource "aws_cloudwatch_metric_alarm" "alarm_up" {
  alarm_name          = "poc_up"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "60"
  statistic           = "Average"
  threshold           = "60"
  alarm_description   = "This metric monitors ec2 cpu utilization UP"

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.scale_group.name
  }

  alarm_actions = [aws_autoscaling_policy.policy_up.arn]
}

resource "aws_cloudwatch_metric_alarm" "alarm_down" {
  alarm_name          = "poc_down"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "60"
  statistic           = "Average"
  threshold           = "20"
  alarm_description   = "This metric monitors ec2 cpu utilization DOWN"

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.scale_group.name
  }

  alarm_actions = [aws_autoscaling_policy.policy_down.arn]
}