terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~>6.36"
    }
  }
}
resource "aws_secretsmanager_secret" "three_tier_secrets" {
  description = "Stores database credentials for RDS"
  name = "three-tier/database"
  kms_key_id = var.kms_key_id
  recovery_window_in_days = 7

  tags = merge(var.common_tags, {
    Name = "three-tier-secrets"
  })
}

resource "aws_secretsmanager_secret_version" "database" {
  secret_id = aws_secretsmanager_secret.three_tier_secrets.id

  secret_string = jsonencode({
    username = var.db_username
    password = var.db_password
  })
}
