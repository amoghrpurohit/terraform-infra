output "vpc_id" {
  value = data.aws_vpc.vpc.id
}
 
output "private_subnet_ids" {
  value = [for s in data.aws_subnet.private-subnets : s.id]
}
 
output "security_group_id" {
  value = data.aws_security_group.sg.id
}
 
# output "transit_gateway_id" {
#   value = data.aws_ec2_transit_gateway.tgw.id
# }
 
# output "transit_gateway_attachment_id" {
#   value = data.aws_ec2_transit_gateway_vpc_attachment.tgw_attachment.id
# }
 
output "route_table_ids" {
  value = [for r in data.aws_route_table.rtb : r.id]
}
 