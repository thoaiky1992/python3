output "db" {
  value = {
    id   = aws_autoscaling_group.ecs_db_auto_scaling_group.id
    name = aws_autoscaling_group.ecs_db_auto_scaling_group.name
  }
}
output "api" {
  value = {
    id   = aws_autoscaling_group.ecs_api_auto_scaling_group.id
    name = aws_autoscaling_group.ecs_api_auto_scaling_group.name
  }
}
output "redis" {
  value = {
    id   = aws_autoscaling_group.ecs_redis_auto_scaling_group.id
    name = aws_autoscaling_group.ecs_redis_auto_scaling_group.name
  }
}
