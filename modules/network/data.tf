# Reference the existing VPC by Name tag
data "aws_vpc" "vpc" {
  filter {
    name   = "tag:Name"
    values = [var.vpc_name]
  }
}
 
# Reference the existing subnets by Name tag and VPC
data "aws_subnet" "private-subnets" {
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
 
# Reference the existing security group by Name tag
data "aws_security_group" "sg" {
  name = var.security_group_name
}
 
# Reference the existing Transit Gateway by Name tag
# data "aws_ec2_transit_gateway" "tgw" {
#   filter {
#     name   = "tag:Name"
#     values = [var.transit_gateway_name]
#   }
# }
 
# data "aws_ec2_transit_gateway_vpc_attachment" "tgw_attachment" {
#   filter {
#     name   = "transit-gateway-id"
#     values = [data.aws_ec2_transit_gateway.tgw.id]
#   }
#   filter {
#     name   = "vpc-id"
#     values = [data.aws_vpc.vpc.id]
#   }
#   # Optionally, filter by state
#   filter {
#     name   = "state"
#     values = ["available"]
#   }
# }
 
# Reference the existing route tables by Name tag and VPC
data "aws_route_table" "rtb" {
  for_each = toset(var.route_table_names)
  filter {
    name   = "tag:Name"
    values = [each.key]
  }
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.vpc.id]
  }
}
 
 