# Tags
variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
}

# # Networking
# variable "vpc_id" {
#   description = "VPC ID"
#   type        = string
# }

# Networking (use Name tags, not IDs)
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
 
variable "transit_gateway_name" {
  description = "The Name tag of the transit gateway"
  type        = string
}
 
variable "route_table_names" {
  description = "List of Name tags for route tables"
  type        = list(string)
}
 
variable "nat_gateway_name" {
  description = "The Name tag of the NAT Gateway"
  type        = string
}
 

# ALB Configuration
variable "alb_name" {
  description = "ALB name"
  type        = string
}

# ECR Configuration
variable "ecr_repo_name" {
  description = "ECR Repository name"
  type        = string
}

# ECS Configuration
variable "ecs_cluster_name" {
  description = "ECS Cluster name"
  type        = string
}

variable "ecs_service_name" {
  description = "ECS Service name"
  type        = string
}

variable "container_name" {
  description = "Container name"
  type        = string
}

variable "container_image" {
  description = "Container image"
  type        = string
}

variable "cpu" {
  description = "CPU for ECS task"
  type        = number
}

variable "memory" {
  description = "Memory for ECS task"
  type        = number
}

variable "container_port" {
  description = "Container port"
  type        = number
}

variable "desired_count" {
  description = "Desired count for ECS task"
  type        = number
}

# Autoscaling Configuration
variable "max_capacity" {
  description = "Max capacity for ECS autoscaling"
  type        = number
}

variable "min_capacity" {
  description = "Min capacity for ECS autoscaling"
  type        = number
}

variable "target_value" {
  description = "Target value for ECS autoscaling"
  type        = number
}

# CloudWatch Configuration
variable "retention_in_days" {
  description = "CloudWatch log retention days"
  type        = number
}

# Environment and Project Configuration
variable "environment" {
  description = "Environment name like dev/staging/prod"
  type        = string
}

variable "project_name" {
  description = "Project name"
  type        = string
}

# Encryption
# variable "kms_key_id" {
#   description = "KMS Key ID for encryption"
#   type        = string
# }

variable "certificate_arn" {
  description = "ARN of the ACM certificate for HTTPS listener"
  type        = string
}