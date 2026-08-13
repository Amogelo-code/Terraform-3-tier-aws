terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~>6.36"
    }
  }
}
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners = ["amazon"]

  filter {
    name = "name"
    values = ["al2023-ami-*-x86_64"]
  }
}

resource "aws_launch_template" "launch_template" {
  name = "3-tier-ec2-template"
  image_id = data.aws_ami.amazon_linux.id
  description = "A launch template designed to create EC2 instances"
  instance_type = "t2.micro"
  user_data = base64encode(file("${path.module}/user_data.sh"))

  network_interfaces {
    associate_public_ip_address = false
    security_groups = var.app_security_groups
  }
  iam_instance_profile {
    name = var.iam_instance_profile
  }
  tag_specifications {
    resource_type = "instance"

    tags = merge(var.common_tags, {
    Name = "3-tier-web"
    })
  }
}

resource "aws_autoscaling_group" "three_tier_asg" {
  name = "3-tier-asg"
  max_size = 4
  min_size = 2
  desired_capacity = 2
  vpc_zone_identifier = var.app_subnet_ids
  health_check_type = "ELB"
  target_group_arns = var.target_group_arn

  launch_template {
    id = aws_launch_template.launch_template.id
    version = "$Latest"
  }
  tag {
    key                 = "AutoScalingGroup"
    propagate_at_launch = true
    value               = "3-tier-asg"
  }
}