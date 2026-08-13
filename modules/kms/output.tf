output "kms_key_arn" {
  value = aws_kms_key.three_tier_kms.arn
}

output "kms_key_id" {
  value = aws_kms_key.three_tier_kms.key_id
}

output "aws_kms_alias" {
  value = aws_kms_alias.three_tier_alias.name
}