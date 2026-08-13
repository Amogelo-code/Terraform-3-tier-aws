terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~>6.36"
    }
  }
}

resource "aws_cloudwatch_log_group" "alb_logs" {
  log_group_class             = "STANDARD"
  deletion_protection_enabled = false
  retention_in_days           = 30
  kms_key_id                  = var.kms_key_id
  name                        = "/aws/three-tier/alb"
  tags = merge(var.common_tags, {
    Name = "three-tier-alb-logs"
  })
}

resource "aws_cloudwatch_metric_alarm" "alb_alarm" {
  alarm_name          = "three-tier-alb-5xx"
  comparison_operator = "GreaterThanThreshold"
  threshold           = 80
  evaluation_periods  = 2
  period              = 300
  statistic           = "Average"
  namespace           = "AWS/ApplicationELB"
  metric_name = "HTTPCode_ELB_5XX_Count"
  dimensions = {
    LoadBalancer = var.alb_arn_suffix
  }
  tags = merge(var.common_tags, {
    Name = "three-tier-alb-alarm"
  })
}

resource "aws_cloudwatch_log_group" "compute_logs" {
  log_group_class             = "STANDARD"
  deletion_protection_enabled = false
  retention_in_days           = 30
  kms_key_id                  = var.kms_key_id
  name                        = "/aws/three-tier/compute"
  tags = merge(var.common_tags, {
    Name = "three-tier-compute-logs"
  })
}

resource "aws_cloudwatch_metric_alarm" "compute_alarm" {
  alarm_name          = "three-tier-compute-cpu"
  comparison_operator = "GreaterThanThreshold"
  threshold           = 80
  evaluation_periods  = 2
  period              = 300
  metric_name         = "CPUUtilization"
  statistic           = "Average"
  namespace           = "AWS/EC2"
  dimensions = {
    AutoScalingGroupName = var.asg_name
  }
  tags = merge(var.common_tags, {
    Name = "three-tier-compute-alarm"
  })
}

resource "aws_cloudwatch_log_group" "database_logs" {
  log_group_class             = "STANDARD"
  deletion_protection_enabled = false
  retention_in_days           = 30
  kms_key_id                  = var.kms_key_id
  name                        = "/aws/three-tier/database"
  tags = merge(var.common_tags, {
    Name = "three-tier-database-logs"
  })
}

resource "aws_cloudwatch_metric_alarm" "database_alarm" {
  alarm_name          = "three-tier-database-cpu"
  comparison_operator = "GreaterThanThreshold"
  threshold           = 80
  evaluation_periods  = 2
  period              = 300
  metric_name         = "CPUUtilization"
  statistic           = "Average"
  namespace           = "AWS/RDS"
  dimensions = {
    DBInstanceIdentifier = var.db_identifier
  }
  tags = merge(var.common_tags, {
    Name = "three-tier-database-alarm"
  })
}