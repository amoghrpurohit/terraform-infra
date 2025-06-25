data "aws_vpc" "vpc" {
  filter {
    name   = "tag:Name"
    values = [var.vpc_name]
  }
}

data "aws_subnet" "private_subnets" {
  for_each = toset(var.private_subnet_names)
  filter {
    name   = "tag:Name"
    values = [each.key]
  }
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.vpc.id]
  }
}

data "aws_security_group" "sg" {
  name = var.security_group_name
}