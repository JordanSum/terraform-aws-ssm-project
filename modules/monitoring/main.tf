terraform {
  required_providers {
    aws = {
      source                = "hashicorp/aws"
      version               = "~> 6.4.0"
      configuration_aliases = [aws.west2, aws.east]
    }
    null = {
      source  = "hashicorp/null"
      version = "~> 3.0"
    }
  }
}

# Create a CloudWatch dashboard for monitoring in West region
resource "aws_cloudwatch_dashboard" "dashboard_west" {
  provider       = aws.west2
  dashboard_name = "${var.project_name}-dashboard-west"

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
            ["AWS/EC2", "CPUUtilization", "InstanceId", var.west_instance_1_id],
            ["AWS/EC2", "CPUUtilization", "InstanceId", var.west_instance_2_id]
          ]
          period = 300
          stat   = "Average"
          region = "us-west-2"
          title  = "West Region EC2 CPU Utilization"
          view   = "timeSeries"
          yAxis = {
            left = {
              min = 0
              max = 100
            }
          }
        }
      },
      {
        type   = "metric"
        x      = 12
        y      = 0
        width  = 12
        height = 6
        properties = {
          metrics = [
            ["AWS/EC2", "NetworkIn", "InstanceId", var.west_instance_1_id],
            ["AWS/EC2", "NetworkIn", "InstanceId", var.west_instance_2_id],
            ["AWS/EC2", "NetworkOut", "InstanceId", var.west_instance_1_id],
            ["AWS/EC2", "NetworkOut", "InstanceId", var.west_instance_2_id]
          ]
          period = 300
          stat   = "Average"
          region = "us-west-2"
          title  = "West Region Network I/O"
          view   = "timeSeries"
        }
      },
      {
        type   = "text"
        x      = 0
        y      = 6
        width  = 24
        height = 2
        properties = {
          markdown = "# West Region Monitoring Dashboard\n\nMonitoring EC2 instances in us-west-2 region. Instances are managed via AWS Systems Manager without SSH access."
        }
      }
    ]
  })
}

# Create a CloudWatch dashboard for monitoring in East region
resource "aws_cloudwatch_dashboard" "dashboard_east" {
  provider       = aws.east
  dashboard_name = "${var.project_name}-dashboard-east"

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
            ["AWS/EC2", "CPUUtilization", "InstanceId", var.east_instance_1_id],
            ["AWS/EC2", "CPUUtilization", "InstanceId", var.east_instance_2_id]
          ]
          period = 300
          stat   = "Average"
          region = "us-east-2"
          title  = "East Region EC2 CPU Utilization"
          view   = "timeSeries"
          yAxis = {
            left = {
              min = 0
              max = 100
            }
          }
        }
      },
      {
        type   = "metric"
        x      = 12
        y      = 0
        width  = 12
        height = 6
        properties = {
          metrics = [
            ["AWS/EC2", "NetworkIn", "InstanceId", var.east_instance_1_id],
            ["AWS/EC2", "NetworkIn", "InstanceId", var.east_instance_2_id],
            ["AWS/EC2", "NetworkOut", "InstanceId", var.east_instance_1_id],
            ["AWS/EC2", "NetworkOut", "InstanceId", var.east_instance_2_id]
          ]
          period = 300
          stat   = "Average"
          region = "us-east-2"
          title  = "East Region Network I/O"
          view   = "timeSeries"
        }
      },
      {
        type   = "text"
        x      = 0
        y      = 6
        width  = 24
        height = 2
        properties = {
          markdown = "# East Region Monitoring Dashboard\n\nMonitoring EC2 instances in us-east-2 region with public access via Elastic IPs. Web servers accessible via HTTP."
        }
      }
    ]
  })
}

# CloudWatch Alarms for West Region
resource "aws_cloudwatch_metric_alarm" "west_cpu_high_1" {
  provider            = aws.west2
  alarm_name          = "${var.project_name}-west-instance-1-cpu-high"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "300"
  statistic           = "Average"
  threshold           = "80"
  alarm_description   = "This metric monitors ec2 cpu utilization for west instance 1"
  alarm_actions       = []

  dimensions = {
    InstanceId = var.west_instance_1_id
  }

  tags = {
    Name        = "${var.project_name}-west-instance-1-cpu-alarm"
    Environment = var.environment
    Region      = "us-west-2"
  }
}

resource "aws_cloudwatch_metric_alarm" "west_cpu_high_2" {
  provider            = aws.west2
  alarm_name          = "${var.project_name}-west-instance-2-cpu-high"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "300"
  statistic           = "Average"
  threshold           = "80"
  alarm_description   = "This metric monitors ec2 cpu utilization for west instance 2"
  alarm_actions       = []

  dimensions = {
    InstanceId = var.west_instance_2_id
  }

  tags = {
    Name        = "${var.project_name}-west-instance-2-cpu-alarm"
    Environment = var.environment
    Region      = "us-west-2"
  }
}

# CloudWatch Alarms for East Region
resource "aws_cloudwatch_metric_alarm" "east_cpu_high_1" {
  provider            = aws.east
  alarm_name          = "${var.project_name}-east-instance-1-cpu-high"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "300"
  statistic           = "Average"
  threshold           = "80"
  alarm_description   = "This metric monitors ec2 cpu utilization for east instance 1"
  alarm_actions       = []

  dimensions = {
    InstanceId = var.east_instance_1_id
  }

  tags = {
    Name        = "${var.project_name}-east-instance-1-cpu-alarm"
    Environment = var.environment
    Region      = "us-east-2"
  }
}

resource "aws_cloudwatch_metric_alarm" "east_cpu_high_2" {
  provider            = aws.east
  alarm_name          = "${var.project_name}-east-instance-2-cpu-high"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "300"
  statistic           = "Average"
  threshold           = "80"
  alarm_description   = "This metric monitors ec2 cpu utilization for east instance 2"
  alarm_actions       = []

  dimensions = {
    InstanceId = var.east_instance_2_id
  }

  tags = {
    Name        = "${var.project_name}-east-instance-2-cpu-alarm"
    Environment = var.environment
    Region      = "us-east-2"
  }
}

# CloudWatch Log Group for SSM Session Manager logs
resource "aws_cloudwatch_log_group" "ssm_session_logs" {
  provider          = aws.west2
  name              = "/aws/ssm/sessions"
  retention_in_days = 30

  tags = {
    Name        = "${var.project_name}-ssm-session-logs"
    Environment = var.environment
    Purpose     = "SSM Session Manager Audit Logs"
  }
}

resource "aws_cloudwatch_log_group" "ssm_session_logs_east" {
  provider          = aws.east
  name              = "/aws/ssm/sessions"
  retention_in_days = 30

  tags = {
    Name        = "${var.project_name}-ssm-session-logs-east"
    Environment = var.environment
    Purpose     = "SSM Session Manager Audit Logs"
  }
}

# Session Manager document for West Region
resource "aws_ssm_document" "session_manager_logging_west" {
  provider = aws.west2
  name     = "${var.project_name}-ssm-session-manager-logging_west"
  document_format = "JSON"
  document_type   = "Session"
  
  content = jsonencode({
    schemaVersion = "1.0"
    description   = "SSM Session Manager Logging for West Region"
    sessionType   = "Standard_Stream"
    inputs = {
      s3BucketName                = ""
      s3KeyPrefix                 = ""
      s3EncryptionEnabled         = true
      cloudWatchLogGroupName      = "/aws/ssm/sessions"
      cloudWatchEncryptionEnabled = false
      cloudWatchStreamingEnabled  = true
      idleSessionTimeout          = "20"
      maxSessionDuration          = "60"
      runAsEnabled                = false
      runAsDefaultUser            = ""
      shellProfile = {
        windows = "date"
        linux   = "pwd;ls"
      }
    }
  })

  tags = {
    Name = "${var.project_name}-ssm-session-manager-logging_west"
  }
}

# Session Manager document for East Region
resource "aws_ssm_document" "session_manager_logging_east" {
  provider = aws.east
  name     = "${var.project_name}-ssm-session-manager-logging_east"
  document_format = "JSON"
  document_type   = "Session"
  
  content = jsonencode({
    schemaVersion = "1.0"
    description   = "SSM Session Manager Logging for East Region"
    sessionType   = "Standard_Stream"
    inputs = {
      s3BucketName                = ""
      s3KeyPrefix                 = ""
      s3EncryptionEnabled         = true
      cloudWatchLogGroupName      = "/aws/ssm/sessions"
      cloudWatchEncryptionEnabled = false
      cloudWatchStreamingEnabled  = true
      idleSessionTimeout          = "20"
      maxSessionDuration          = "60"
      runAsEnabled                = false
      runAsDefaultUser            = ""
      shellProfile = {
        windows = "date"
        linux   = "pwd;ls"
      }
    }
  })

  tags = {
    Name = "${var.project_name}-ssm-session-manager-logging_east"
  }
}

# Cost monitoring and alerts in West region
resource "aws_budgets_budget" "monthly_cost_budget_west" {
  provider = aws.west2
  name     = "${var.project_name}-monthly-cost-budget-west"
  budget_type = "COST"
  limit_amount = "10"
  limit_unit   = "USD"
  time_unit   = "MONTHLY"

  cost_filter {
    name   = "Service"
    values = [
      "AmazonEC2"
    ]
  }

  notification {
    comparison_operator = "GREATER_THAN"
    threshold           = 80
      threshold_type      = "PERCENTAGE"
      notification_type   = "FORECASTED"
      subscriber_email_addresses = ["jsum9712@gmail.com"]
    }
    tags = {
        Name        = "${var.project_name}-cost-budget"
    }
}

# Cost monitoring and alerts in East region
resource "aws_budgets_budget" "monthly_cost_budget_east" {
  provider = aws.east
  name     = "${var.project_name}-monthly-cost-budget-east"
  budget_type = "COST"
  limit_amount = "10"
  limit_unit   = "USD"
  time_unit   = "MONTHLY"

  cost_filter {
    name   = "Service"
    values = [
      "AmazonEC2"
    ]
  }

  notification {
    comparison_operator = "GREATER_THAN"
    threshold           = 80
      threshold_type      = "PERCENTAGE"
      notification_type   = "FORECASTED"
      subscriber_email_addresses = ["jsum9712@gmail.com"]
    }
    tags = {
        Name        = "${var.project_name}-cost-budget"
    }
}

# Data source to get current AWS account ID and region
data "aws_caller_identity" "current" {}

# CloudWatch Logs resource policy to allow SSM to write session logs
resource "aws_cloudwatch_log_resource_policy" "session_manager_logging_west" {
  provider        = aws.west2
  policy_name     = "${var.project_name}-session-manager-logging-west"
  policy_document = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ssm.amazonaws.com"
        }
        Action = [
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Resource = "arn:aws:logs:us-west-2:${data.aws_caller_identity.current.account_id}:log-group:/aws/ssm/sessions:*"
      }
    ]
  })
}