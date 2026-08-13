module "alb" {
  source         = "./modules/alb"
  vpc_id         = module.network.vpc_id
  common_tags    = local.common_tags
  alb_security_group = [module.security.alb_sg]
  public_subnets = module.network.public_subnet_ids
}

module "compute" {
  source               = "./modules/compute"
  common_tags          = local.common_tags
  iam_instance_profile = module.iam.aws_iam_instance_profile
  app_subnet_ids       = module.network.app_subnet_ids
  app_security_groups  = [module.security.app_sg]
  target_group_arn     = [module.alb.aws_target_group_arn]
}

module "database" {
  source            = "./modules/database"
  common_tags       = local.common_tags
  db_subnets        = module.network.db_subnet_ids
  db_password       = var.db_password
  db_security_group = [module.security.db_sg]
  db_username       = var.db_username
  kms_key_id        = module.kms.kms_key_id

}
module "iam" {
  source      = "./modules/iam"
  common_tags = local.common_tags
}

module "kms" {
  source      = "./modules/kms"
  common_tags = local.common_tags
}

module "monitoring" {
  source         = "./modules/monitoring"
  common_tags    = local.common_tags
  alb_arn_suffix = module.alb.aws_lb_arn_suffix
  asg_name       = module.compute.asg_name
  db_identifier  = module.database.db_identifier
  kms_key_id     = module.kms.kms_key_id
}

module "network" {
  source       = "./modules/network"
  project_name = var.project_name
  environment  = var.environment
  common_tags  = local.common_tags
}

module "secrets_manager" {
  source      = "./modules/secrets_manager"
  common_tags = local.common_tags
  db_password = var.db_password
  db_username = var.db_username
  kms_key_id  = module.kms.kms_key_id
}

module "security" {
  source      = "./modules/security"
  vpc_id      = module.network.vpc_id
  common_tags = local.common_tags
}
