output "vpc_id" {
  value = aws_vpc.vpc_main.id
}

output "public_subnet_ids" {
  value = [aws_subnet.public_az.id,
            aws_subnet.public_az2.id]
}

output "db_subnet_ids" {
  value = [aws_subnet.db_az1.id,
           aws_subnet.db_az2.id]
}

output "app_subnet_ids" {
  value = [aws_subnet.app_az1.id,
           aws_subnet.app_az2.id]
}

output "nat_gateway" {
  value = aws_nat_gateway.nat.id
}