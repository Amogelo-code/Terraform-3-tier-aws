terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~>6.36"
    }
  }
}
resource "aws_kms_key" "three_tier_kms" {
  key_usage = "ENCRYPT_DECRYPT"
  enable_key_rotation = true
  deletion_window_in_days = 7
  description = "An encryption key that is used for the protection of services within this three tier architecture"
  tags = merge(var.common_tags, {
    Name = "three-tier-kms-key"
  })
}

resource "aws_kms_alias" "three_tier_alias" {
  target_key_id = aws_kms_key.three_tier_kms.key_id
  name = "alias/three-tier-key"
}
