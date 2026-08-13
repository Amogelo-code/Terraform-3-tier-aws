output "secrets_arn" {
  value = aws_secretsmanager_secret.three_tier_secrets.arn
}
