# CloudWatch Logs -> Metric Filter -> Alarm + SNS
resource "aws_cloudwatch_log_metric_filter" "match_filter" {
  name           = "${var.alarm_name}-filter"
  log_group_name = var.log_group_name
  # literal substring match: "ALERT_TRIGGER"
  pattern        = "\"${var.match_string}\""

  metric_transformation {
    name      = "${var.alarm_name}-metric"
    namespace = "Custom/LogMatches"
    value     = "1"
  }
}

resource "aws_sns_topic" "alarm_topic" {
  name = "${var.alarm_name}-topic"
}

resource "aws_sns_topic_subscription" "email" {
  topic_arn = aws_sns_topic.alarm_topic.arn
  protocol  = "email"
  endpoint  = var.alarm_email
}

resource "aws_cloudwatch_metric_alarm" "log_line_alarm" {
  alarm_name          = var.alarm_name
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 1
  period              = 60
  threshold           = var.threshold_per_min
  statistic           = "Sum"

  metric_name = aws_cloudwatch_log_metric_filter.match_filter.metric_transformation[0].name
  namespace   = "Custom/LogMatches"

  alarm_description  = "Alarm when '${var.match_string}' occurs >= ${var.threshold_per_min} times in 1 minute."
  treat_missing_data = "notBreaching"

  alarm_actions = [aws_sns_topic.alarm_topic.arn]
  ok_actions    = [aws_sns_topic.alarm_topic.arn]
}
