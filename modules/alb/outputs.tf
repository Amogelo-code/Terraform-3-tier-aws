output "aws_lb_dns_name" {
  value = aws_lb.alb.dns_name
}

output "aws_target_group_arn" {
  value = aws_lb_target_group.alb_tg.arn
}

output "aws_lb_arn" {
  value = aws_lb.alb.arn
}

output "aws_lb_arn_suffix" {
  value = aws_lb.alb.arn_suffix
}