output "aws_iam_instance_profile" {
  value = aws_iam_instance_profile.ec2_instance_profile.name
}

output "aws_iam_role" {
  value = aws_iam_role.ec2_3_tier_role.name
}