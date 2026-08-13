output "launch_template" {
  value = aws_launch_template.launch_template.id
}

output "asg_name" {
  value = aws_autoscaling_group.three_tier_asg.name
}