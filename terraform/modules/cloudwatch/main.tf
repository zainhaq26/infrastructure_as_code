# CloudWatch Log Group
resource "aws_cloudwatch_log_group" "main" {
  count = var.create_log_group ? 1 : 0

  name              = var.log_group_name
  retention_in_days = var.log_retention_in_days
  kms_key_id        = var.kms_key_id

  tags = merge(var.tags, {
    Name = var.log_group_name
  })
}

# CloudWatch Log Stream
resource "aws_cloudwatch_log_stream" "main" {
  count = var.create_log_stream ? 1 : 0

  name           = var.log_stream_name
  log_group_name = var.log_group_name != "" ? var.log_group_name : aws_cloudwatch_log_group.main[0].name
}

# CloudWatch Metric Alarm
resource "aws_cloudwatch_metric_alarm" "main" {
  for_each = var.metric_alarms

  alarm_name          = each.value.alarm_name
  comparison_operator = each.value.comparison_operator
  evaluation_periods  = each.value.evaluation_periods
  metric_name         = each.value.metric_name
  namespace           = each.value.namespace
  period              = each.value.period
  statistic           = each.value.statistic
  threshold           = each.value.threshold
  alarm_description   = each.value.alarm_description
  alarm_actions       = each.value.alarm_actions
  ok_actions          = each.value.ok_actions
  insufficient_data_actions = each.value.insufficient_data_actions

  dimensions = each.value.dimensions

  tags = merge(var.tags, {
    Name = each.value.alarm_name
  })
}

# CloudWatch Dashboard
resource "aws_cloudwatch_dashboard" "main" {
  count = var.create_dashboard ? 1 : 0

  dashboard_name = var.dashboard_name
  dashboard_body = var.dashboard_body

  tags = merge(var.tags, {
    Name = var.dashboard_name
  })
}

# CloudWatch Event Rule
resource "aws_cloudwatch_event_rule" "main" {
  for_each = var.event_rules

  name                = each.value.name
  description         = each.value.description
  schedule_expression = each.value.schedule_expression
  event_pattern       = each.value.event_pattern
  state               = each.value.state

  tags = merge(var.tags, {
    Name = each.value.name
  })
}

# CloudWatch Event Target
resource "aws_cloudwatch_event_target" "main" {
  for_each = var.event_targets

  rule      = each.value.rule_name
  target_id = each.value.target_id
  arn       = each.value.arn

  dynamic "input" {
    for_each = each.value.input != null ? [each.value.input] : []
    content {
      input = input.value
    }
  }

  dynamic "input_path" {
    for_each = each.value.input_path != null ? [each.value.input_path] : []
    content {
      input_path = input_path.value
    }
  }
}
