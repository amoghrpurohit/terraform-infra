resource "aws_iam_role" "ecs_task_execution_role" {
  name = "ecs_task_execution_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
  tags = var.tags
}
 
resource "aws_iam_role_policy_attachment" "ecs_task_execution_role_policy" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_role_policy_attachment" "ecs_logs_policy" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchLogsFullAccess"
}

# resource "aws_iam_role_policy_attachment" "ecs_ecr_policy" {
#   role       = aws_iam_role.ecs_task_execution_role.name
#   policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
# }

resource "aws_ecs_cluster" "cvist-ecs-cluster" {
  name = var.ecs_cluster_name

  tags = var.tags
}

resource "aws_ecs_task_definition" "cvist-ecs-task" {
  family                   = var.ecs_service_name
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.cpu
  memory                   = var.memory
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn   # <-- Add this line
  task_role_arn            = aws_iam_role.ecs_task_execution_role.arn
  container_definitions = jsonencode([{
  name      = var.container_name
  image     = var.container_image
  essential = true
  memory    = var.memory
  cpu       = var.cpu
  portMappings = [
      {
        containerPort = var.container_port
        hostPort      = var.container_port
        protocol      = "tcp"
      },
    ]
    logConfiguration = {
      logDriver = "awslogs"
      options = {
        awslogs-group         = "/ecs/${var.ecs_service_name}"
        awslogs-region        = var.aws_region
        awslogs-stream-prefix = "ecs"
      }
    }
    healthCheck = {
      command     = ["CMD-SHELL", "curl -kf http://localhost:${var.container_port}/cvist/start || exit 1"]
      interval    = 30
      timeout     = 20
      retries     = 3
      startPeriod = 30
    }
  }])
  tags = var.tags
}
 
resource "aws_ecs_service" "cvist-ecs-service" {
  name            = var.ecs_service_name
  cluster         = aws_ecs_cluster.cvist-ecs-cluster.id
  task_definition = aws_ecs_task_definition.cvist-ecs-task.arn
  desired_count   = var.desired_count
  launch_type     = "FARGATE"

  network_configuration {
    security_groups = [data.aws_security_group.sg.id]
    subnets            = [for s in data.aws_subnet.private_subnets : s.id]
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = var.target_group_arn
    container_name   = var.container_name
    container_port   = var.container_port
  }

  tags = var.tags 
}

resource "aws_appautoscaling_target" "cvist-autoscale-target" {
  max_capacity       = var.max_capacity
  min_capacity       = var.min_capacity
  resource_id        = "service/${aws_ecs_cluster.cvist-ecs-cluster.name}/${aws_ecs_service.cvist-ecs-service.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"

  tags = var.tags
}

resource "aws_appautoscaling_policy" "cvist-autoscale-policy" {
  name                   = "cvist-autoscale-policy"
  policy_type            = "TargetTrackingScaling"
  resource_id            = aws_appautoscaling_target.cvist-autoscale-target.resource_id
  scalable_dimension     = aws_appautoscaling_target.cvist-autoscale-target.scalable_dimension
  service_namespace      = aws_appautoscaling_target.cvist-autoscale-target.service_namespace

  target_tracking_scaling_policy_configuration {
    target_value         = var.target_value
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }
  }
}