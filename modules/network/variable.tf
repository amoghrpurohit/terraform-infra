variable "vpc_name" {
  description = "The Name tag of the VPC"
  type        = string
}
 
variable "private_subnet_names" {
  description = "List of Name tags for private subnets"
  type        = list(string)
}
 
variable "security_group_name" {
  description = "The Name tag of the security group"
  type        = string
}
 
# variable "transit_gateway_name" {
#   description = "The Name tag of the transit gateway"
#   type        = string
# }
 
variable "route_table_names" {
  description = "List of Name tags for route tables"
  type        = list(string)
}
 
variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}

# variable "aws_region" {
#   description = "AWS region"
#   type        = string
# }
 