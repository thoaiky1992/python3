# --- START LOAD BALANCER FOR API ---
resource "aws_lb" "ecs_api_load_balancer" {
  name               = "${replace(var.tag_version, ".", "-")}-ecs-api-load-balancer"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.security_groups["default-security-group"].id]
  subnets            = var.subnet_ids.public

  tags = {
    Name = "${var.tag_version}-ecs-api-alb"
  }
}
resource "aws_lb_target_group" "ecs_api_target_group" {
  name        = "${replace(var.tag_version, ".", "-")}-ecs-api-target-group"
  port        = 4000
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = var.vpc_id

  health_check {
    path = "/api/health-check"
  }
}

resource "aws_lb_listener" "ecs_api_alb_listener" {
  load_balancer_arn = aws_lb.ecs_api_load_balancer.arn
  port              = 4000
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ecs_api_target_group.arn
  }
}
# --- END LOAD BALANCER FOR API ---
