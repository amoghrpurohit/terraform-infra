variable "alb_name" {
  description = "Name of the Application Load Balancer"
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

variable "vpc_name" {
  description = "VPC ID where the target group will be created"
  type        = string
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
}
variable "alb_listener_port" {
  description = "Port for the ALB listener (usually 443 for HTTPS)"
  type        = number
  default     = 443
}
 
variable "target_group_port" {
  description = "Port for the target group (the port your ECS container listens on)"
  type        = number
  default     = 8443
}
variable "certificate_arn" {
  description = "ARN of the SSL certificate for HTTPS listener"
  type        = string
  default     = "" # Optional, if HTTPS is not used
}

