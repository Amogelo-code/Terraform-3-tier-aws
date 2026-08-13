terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~>6.36"
    }
  }
}

resource "aws_db_subnet_group" "db_subnets" {
  subnet_ids = var.db_subnets
  tags = merge(var.common_tags, {
    Name = "db-subnets"
  })
}
resource "aws_db_instance" "rds_db" {
  instance_class = "db.t3.micro"
  engine = "mysql"
  engine_version = "8.4.9"
  password = var.db_password
  username = var.db_username
  db_name = "threetierdb"
  db_subnet_group_name = aws_db_subnet_group.db_subnets.name
  identifier = "three-tier-db"
  storage_type = "gp3"
  port = 3306
  kms_key_id = var.kms_key_id
  storage_encrypted = true
  allocated_storage = 20
  enabled_cloudwatch_logs_exports = ["error","general","slowquery"]
  skip_final_snapshot = true
  vpc_security_group_ids = var.db_security_group
  multi_az = false
  publicly_accessible = false
  tags = merge(var.common_tags, {
    Name = "three-tier-db"
  })
}
