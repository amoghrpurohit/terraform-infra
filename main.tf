module "network" {
  source                = "./modules/network"
  vpc_name              = var.vpc_name
  private_subnet_names  = var.private_subnet_names
  security_group_name   = var.security_group_name
  transit_gateway_name  = var.transit_gateway_name
  route_table_names     = var.route_table_names
  nat_gateway_name      = var.nat_gateway_name
  tags                  = var.tags
}

module "alb" {
  source            = "./modules/alb"
  alb_name          = var.alb_name
  security_group_id = module.network.security_group_id
  subnet_ids        = module.network.private_subnet_ids
  vpc_name          = var.vpc_name
  alb_port          = var.container_port # or 8443 if you want to hardcode
  certificate_arn   = var.certificate_arn # or your cert ARN
  tags              = var.tags
}

module "ecr" {
  source        = "./modules/ecr"
  ecr_repo_name = var.ecr_repo_name
  tags          = var.tags
}

module "ecs" {
  source = "./modules/ecs"

  ecs_cluster_name   = var.ecs_cluster_name
  ecs_service_name   = var.ecs_service_name
  container_name     = var.container_name
  container_image    = var.container_image
  cpu                = var.cpu
  memory             = var.memory
  container_port     = var.container_port
  desired_count      = var.desired_count
  subnet_ids         = module.network.private_subnet_ids
  security_group_id  = module.network.security_group_id
  max_capacity       = var.max_capacity
  min_capacity       = var.min_capacity
  target_value       = var.target_value

  target_group_arn   = module.alb.target_group_arn
  lb_listener_arn    = module.alb.lb_listener_arn              

  tags               = var.tags
}


module "cloudwatch" {
  source            = "./modules/cloudwatch"
  ecs_service_name  = var.ecs_service_name
  retention_in_days = var.retention_in_days
  tags              = var.tags
}