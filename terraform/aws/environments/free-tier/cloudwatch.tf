# Free Tier CloudWatch Configuration
# Deploy with: terraform apply -target=aws_cloudwatch_log_group.free_tier

# CloudWatch Log Group
resource "aws_cloudwatch_log_group" "free_tier" {
  name              = "/aws/free-tier/${var.project_name}"
  retention_in_days = 1  # Minimal retention

  tags = {
    Environment = "free-tier"
    Purpose     = "learning"
    FreeTier    = "true"
    Name        = "/aws/free-tier/${var.project_name}"
  }
}

# CloudWatch Metric Alarm for EC2 CPU
resource "aws_cloudwatch_metric_alarm" "ec2_cpu_high" {
  alarm_name          = "free-tier-ec2-cpu-high"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "300"
  statistic           = "Average"
  threshold           = "80"
  alarm_description   = "EC2 CPU usage is high"
  alarm_actions       = []

  tags = {
    Environment = "free-tier"
    Purpose     = "learning"
    FreeTier    = "true"
    Name        = "free-tier-ec2-cpu-high"
  }
}
