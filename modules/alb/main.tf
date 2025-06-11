resource "aws_lb" "alb-main" {
  name               = var.alb_name
  internal           = true
  load_balancer_type = "application"
  security_groups    = [var.security_group_id]
  subnets            = var.subnet_ids
  ip_address_type    = "ipv4"

  tags = var.tags
} 

resource "aws_lb_target_group" "alb-tg" {
  name     = "${var.alb_name}-tg"
  port     = var.alb_port
  protocol = "HTTP" # Change to "HTTPS" if needed
  vpc_id   = data.aws_vpc.vpc.id

  target_type = "ip"

  health_check {
    path                = "/cvist/start"
    protocol            = "HTTP"
    matcher             = "200-399"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  tags = var.tags
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.alb-main.arn
  port              = var.alb_port
  protocol          = "HTTPS" # Change to "HTTPS" if needed

  # Uncomment the following lines if using HTTPS
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = var.certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb-tg.arn
  }

  tags = var.tags
}