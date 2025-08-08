# Dashboard URLs
output "west_dashboard_url" {
  description = "URL for the West region CloudWatch dashboard"
  value       = "https://us-west-2.console.aws.amazon.com/cloudwatch/home?region=us-west-2#dashboards:name=${aws_cloudwatch_dashboard.dashboard_west.dashboard_name}"
}

output "east_dashboard_url" {
  description = "URL for the East region CloudWatch dashboard"
  value       = "https://us-east-2.console.aws.amazon.com/cloudwatch/home?region=us-east-2#dashboards:name=${aws_cloudwatch_dashboard.dashboard_east.dashboard_name}"
}

# Dashboard names
output "west_dashboard_name" {
  description = "Name of the West region CloudWatch dashboard"
  value       = aws_cloudwatch_dashboard.dashboard_west.dashboard_name
}

output "east_dashboard_name" {
  description = "Name of the East region CloudWatch dashboard"
  value       = aws_cloudwatch_dashboard.dashboard_east.dashboard_name
}

# CloudWatch Log Groups
output "ssm_log_group_west" {
  description = "CloudWatch Log Group for SSM sessions in West region"
  value       = aws_cloudwatch_log_group.ssm_session_logs.name
}

output "ssm_log_group_east" {
  description = "CloudWatch Log Group for SSM sessions in East region"
  value       = aws_cloudwatch_log_group.ssm_session_logs_east.name
}

# Alarm names for reference
output "cpu_alarm_names" {
  description = "Names of all CPU utilization alarms"
  value = {
    west_instance_1 = aws_cloudwatch_metric_alarm.west_cpu_high_1.alarm_name
    west_instance_2 = aws_cloudwatch_metric_alarm.west_cpu_high_2.alarm_name
    east_instance_1 = aws_cloudwatch_metric_alarm.east_cpu_high_1.alarm_name
    east_instance_2 = aws_cloudwatch_metric_alarm.east_cpu_high_2.alarm_name
  }
}