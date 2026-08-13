output "alb_dns_name" {
  value = module.alb.aws_lb_dns_name
}

output "vpc_id" {
  value = module.network.vpc_id
}

output "rds_identifier" {
  value = module.database.db_identifier
}

output "asg_name" {
  value = module.compute.asg_name
}

output "kms_key_arn" {
  value = module.kms.kms_key_arn
}

output "secret_arn" {
  value = module.secrets_manager.secrets_arn
}