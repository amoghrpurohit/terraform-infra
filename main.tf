module "network" {
  source                = "./modules/network"
  vpc_name              = var.vpc_name
  private_subnet_names  = var.private_subnet_names
  security_group_name   = var.security_group_name
  route_table_names     = var.route_table_names
  tags                  = var.tags
}

module "alb" {
  source               = "./modules/alb"
  alb_name             = var.alb_name
  vpc_name             = var.vpc_name
  private_subnet_names = var.private_subnet_names
  security_group_name  = var.security_group_name
  alb_listener_port  = var.alb_listener_port
  target_group_port  = var.target_group_port
  certificate_arn      = var.certificate_arn
  tags                 = var.tags
}

module "ecr" {
  source        = "./modules/ecr"
  ecr_repo_name = var.ecr_repo_name
  tags          = var.tags
}

module "ecs" {
  source = "./modules/ecs"
 
  ecs_cluster_name     = var.ecs_cluster_name
  ecs_service_name     = var.ecs_service_name
  container_name       = var.container_name
  container_image      = var.container_image
  cpu                  = var.cpu
  memory               = var.memory
  container_port       = var.container_port
  desired_count        = var.desired_count
  private_subnet_names = var.private_subnet_names
  security_group_name  = var.security_group_name
  vpc_name             = var.vpc_name         
  aws_region           = var.aws_region
  max_capacity         = var.max_capacity
  min_capacity         = var.min_capacity
  target_value         = var.target_value
 
  target_group_arn     = module.alb.target_group_arn
  lb_listener_arn      = module.alb.lb_listener_arn              
  tags                 = var.tags
}

module "cloudwatch" {
  source            = "./modules/cloudwatch"
  ecs_service_name  = var.ecs_service_name
  retention_in_days = var.retention_in_days
  tags              = var.tags
}