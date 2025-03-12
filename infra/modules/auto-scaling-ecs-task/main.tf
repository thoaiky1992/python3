resource "aws_appautoscaling_target" "as_ecs_db_service" {
  max_capacity       = 1
  min_capacity       = 1
  resource_id        = "service/${var.ecs_cluster.name}/${var.ecs_service.db.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}

resource "aws_appautoscaling_target" "as_ecs_pgbouncer_service" {
  max_capacity       = 1
  min_capacity       = 1
  resource_id        = "service/${var.ecs_cluster.name}/${var.ecs_service.pgbouncer.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}
resource "aws_appautoscaling_target" "as_ecs_redis_service" {
  max_capacity       = 1
  min_capacity       = 1
  resource_id        = "service/${var.ecs_cluster.name}/${var.ecs_service.redis.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}