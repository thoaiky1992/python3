output "lb_target_groups" {
  value = {
    api = {
      arn = aws_lb_target_group.ecs_api_target_group.arn
    }
  }
}
output "api" {
  value = {
    dns_name = aws_lb.ecs_api_load_balancer.dns_name
  }
}

