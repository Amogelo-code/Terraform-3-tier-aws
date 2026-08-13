terraform {
  required_version = ">=v1.15.7"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~>6.36"
    }
  }
}
resource "aws_vpc" "vpc_main" {
  cidr_block = "10.0.0.0/16"

  tags = merge(var.common_tags, {
    Name = "three-tier-vpc"
  })
}

resource "aws_subnet" "public_az" {
  vpc_id            = aws_vpc.vpc_main.id
  availability_zone = "eu-central-1a"
  cidr_block        = "10.0.1.0/24"
  map_public_ip_on_launch = true

  tags = merge(var.common_tags,{
    Name = "3-tier-publicAZ1-subnet"
  })
}

resource "aws_subnet" "public_az2" {
  vpc_id            = aws_vpc.vpc_main.id
  availability_zone = "eu-central-1b"
  cidr_block        = "10.0.2.0/24"
  map_public_ip_on_launch = true

  tags = merge(var.common_tags,{
    Name = "3-tier-publicAZ2-subnet"
  })
}

resource "aws_subnet" "app_az1" {
  vpc_id            = aws_vpc.vpc_main.id
  availability_zone = "eu-central-1a"
  cidr_block        = "10.0.3.0/24"
  map_public_ip_on_launch = false

  tags = merge(var.common_tags,{
    Name = "3-tier-app-AZ1-subnet"
  })
}

resource "aws_subnet" "app_az2" {
  vpc_id            = aws_vpc.vpc_main.id
  availability_zone = "eu-central-1b"
  cidr_block        = "10.0.4.0/24"
  map_public_ip_on_launch = false

  tags = merge(var.common_tags,{
    Name = "3-tier-app-AZ2-subnet"
  })
}

resource "aws_subnet" "db_az1" {
  vpc_id            = aws_vpc.vpc_main.id
  availability_zone = "eu-central-1a"
  cidr_block        = "10.0.5.0/24"
  map_public_ip_on_launch = false

  tags = merge(var.common_tags,{
    Name = "3-tier-DB-AZ1-subnet"
  })
}

resource "aws_subnet" "db_az2" {
  vpc_id            = aws_vpc.vpc_main.id
  availability_zone = "eu-central-1b"
  cidr_block        = "10.0.6.0/24"
  map_public_ip_on_launch = false

  tags = merge(var.common_tags,{
    Name = "3-tier-DB-AZ2-subnet"
  })
}

resource "aws_internet_gateway" "igw_main" {
  vpc_id = aws_vpc.vpc_main.id

  tags = merge(var.common_tags,{
    Name = "3-tier-igw"
  })
}

resource "aws_eip" "eip" {
  domain = "vpc"

  tags = merge(var.common_tags, {
    Name = "3-tier-eipAZ1"
  })
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.eip.id
  subnet_id     = aws_subnet.public_az.id
  depends_on    = [aws_internet_gateway.igw_main]


  tags = merge(var.common_tags, {
    Name = "3-tier-nat"
  })
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.vpc_main.id

  tags = merge(var.common_tags, {
    Name = "3-tier-public"
  })
}

resource "aws_route" "public_default" {
  route_table_id         = aws_route_table.public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw_main.id
}

resource "aws_route_table" "app_rt" {
  vpc_id = aws_vpc.vpc_main.id

  tags = merge(var.common_tags, {
    Name = "3-tier-private-rt"
  })
}

resource "aws_route" "app_default" {
  route_table_id         = aws_route_table.app_rt.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat.id
}

resource "aws_route_table" "db_rt" {
  vpc_id = aws_vpc.vpc_main.id

  tags = merge(var.common_tags, {
    Name = "3-tier-database-rt"
  })
}

resource "aws_route" "db_default" {
  route_table_id         = aws_route_table.db_rt.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat.id
}

resource "aws_route_table_association" "public_az1_rta" {
  route_table_id = aws_route_table.public_rt.id
  subnet_id      = aws_subnet.public_az.id
}

resource "aws_route_table_association" "public_az2_rta" {
  route_table_id = aws_route_table.public_rt.id
  subnet_id      = aws_subnet.public_az2.id
}

resource "aws_route_table_association" "app_az1_rta" {
  route_table_id = aws_route_table.app_rt.id
  subnet_id = aws_subnet.app_az1.id
}

resource "aws_route_table_association" "app_az2_rta" {
  route_table_id = aws_route_table.app_rt.id
  subnet_id = aws_subnet.app_az2.id
}

resource "aws_route_table_association" "db_az1_rta" {
  route_table_id = aws_route_table.db_rt.id
  subnet_id = aws_subnet.db_az1.id
}

resource "aws_route_table_association" "db_az2_rta" {
  route_table_id = aws_route_table.db_rt.id
  subnet_id      = aws_subnet.db_az2.id
}
