terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~>6.36"
    }
  }
}
resource "aws_security_group" "alb_sg" {
  name = "3-tier-alb-sg"
  description = "A security group for incoming public traffic"
  vpc_id = var.vpc_id

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port = 80
    to_port = 80
    protocol = "tcp"
    description = "inbound HTTP access"
  }
  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port = 443
    to_port = 443
    protocol = "tcp"
    description = "inbound HTTPS access"
  }
  egress {
    cidr_blocks = ["0.0.0.0/0"]
    protocol = "-1"
    from_port = 0
    to_port = 0
    description = "Allow all outbound access"
  }
  tags = merge(var.common_tags, {
    Name = "3-tier-alb-sg"
  })
}

resource "aws_security_group" "app_sg" {
  name = "3-tier-app-sg"
  description = "a security group dedicated specifically for the private app"
  vpc_id = var.vpc_id

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    description = "outbound access from the app_sg to the database sg"
    security_groups = ["0.0.0.0/0"]
  }
  tags = merge(var.common_tags, {
    Name = "3-tier-app-sg"
  })
}

resource "aws_security_group" "db_sg" {
  name = "3-tier-db-sg"
  description = "the security group for the MYSQL database"
  vpc_id = var.vpc_id

  ingress {
    from_port = 3306
    to_port = 3306
    protocol = "tcp"
    security_groups = [aws_security_group.app_sg.id]
    description = "inbound access from the app security group into the database security group"
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "allow for all outbound traffic"
  }
  tags = merge(var.common_tags, {
    Name = "3-tier-db-sg"
  })
}