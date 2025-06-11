# The ID of the VPC where resources will be deployed
# vpc_id = "vpc-0d912a591fe34de43"

# The Name tag of the VPC where resources will be deployed
vpc_name = "ecn1-VPC"
 
# List of Name tags for private subnets
private_subnet_names = ["ecn1-PrivateSubnet1", "ecn1-PrivateSubnet2"]
 
# Security group Name tag for ECS and ALB
security_group_name = "sg_app"
 
# Transit Gateway Name tag
transit_gateway_name = "my-transit-gateway"
 
# Route table Name tags for the subnets
route_table_names = ["ecn1-PrivateRouteTable1", "ecn1-PrivateRouteTable2"]
 
# NAT Gateway Name tag
nat_gateway_name = "my-nat-gateway"

# ECR repository name
ecr_repo_name = "cvist-app-ecr-repo"

# KMS Key ID for encryption
# kms_key_id = "arn:aws:kms:eu-west-1:ACCOUNT_ID:key/KEY_ID"

# ECS cluster and service configuration
ecs_cluster_name = "cvist-ecs-cluster"
ecs_service_name = "cvist-ecs-service"
container_name   = "cvist-ecr-container"
container_image  = "288627860431.dkr.ecr.eu-west-1.amazonaws.com/cvist-app-ecr-repo:latest"
container_port   = 8443
desired_count    = 1
cpu              = 256
memory           = 512
max_capacity     = 10
min_capacity     = 1
target_value     = 50
environment      = "non-prod"
project_name     = "my-project"

# ALB name
alb_name = "cvist-alb-nonprod"
certificate_arn = "arn:aws:acm:eu-west-1:288627860431:certificate/51f91368-1421-473f-b76d-36214367b795"

# Tags to apply to all resources
tags = {
  Environment = "Non-Production"
  Owner       = "DevOps"
  Project     = "Terraform-CVIST"
}

retention_in_days = 30