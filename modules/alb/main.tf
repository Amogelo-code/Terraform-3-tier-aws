terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~>6.36"
    }
  }
}
resource "aws_lb" "alb" {
  subnets = var.public_subnets
  load_balancer_type = "application"
  internal = false
  security_groups = var.alb_security_group

  tags = merge(var.common_tags, {
    Name = "three-tier-alb"
  })
}

resource "aws_lb_target_group" "alb_tg" {
  port = 80
  vpc_id = var.vpc_id
  protocol = "HTTP"
  target_type = "instance"
  health_check {
    path = "/"
    protocol = "HTTP"
    matcher = "200"
    interval = 30
    timeout = 5
    unhealthy_threshold = 2
    healthy_threshold = 5
  }
  tags = merge(var.common_tags, {
    Name = "three-tier-target-group"
  })
}

resource "aws_lb_listener" "alb_listener" {
  load_balancer_arn = aws_lb.alb.arn
  port = 80
  protocol = "HTTP"

  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.alb_tg.arn
  }
  tags = merge(var.common_tags, {
    Name = "three-tier-listener"
  })
}