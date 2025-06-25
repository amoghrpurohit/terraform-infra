resource "aws_lb" "alb-main" {
  name               = var.alb_name
  internal           = true
  load_balancer_type = "application"
  security_groups    = [data.aws_security_group.sg.id]
  subnets            = [for s in data.aws_subnet.private_subnets : s.id]
  ip_address_type    = "ipv4"

  tags = var.tags
} 

resource "aws_lb_target_group" "alb-tg" {
  name     = "${var.alb_name}-tg"
  port     = var.target_group_port
  protocol = "HTTP" # Change to "HTTPS" if needed
  vpc_id   = data.aws_vpc.vpc.id

  target_type = "ip"

  health_check {
    path                = "/cvist/start"
    protocol            = "HTTP"
    matcher             = "200-399"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 5
    unhealthy_threshold = 2
  }

  tags = var.tags
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.alb-main.arn
  port              = var.alb_listener_port
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