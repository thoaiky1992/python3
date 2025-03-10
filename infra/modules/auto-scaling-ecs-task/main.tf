resource "aws_appautoscaling_target" "as_ecs_db_service" {
  max_capacity       = 1
  min_capacity       = 1
  resource_id        = "service/${var.ecs_cluster.db.name}/${var.ecs_service.db.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}
