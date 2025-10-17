output "alarm_arn" {
  value = aws_cloudwatch_metric_alarm.log_line_alarm.arn
}

output "sns_topic_arn" {
  value = aws_sns_topic.alarm_topic.arn
}
