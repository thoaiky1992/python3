resource "aws_ecs_service" "ecs_db_service" {
  name            = "${replace(var.tag_version, ".", "-")}-ecs-db-service"
  cluster         = var.ecs_cluster.db.id
  task_definition = var.ecs_task_definition.db.arn
  desired_count   = 1
  launch_type     = "EC2"

  force_new_deployment = true

  placement_constraints {
    type = "distinctInstance"
  }

  service_registries {
    registry_arn = var.db_service_discovery_service.arn
  }

  network_configuration {
    subnets         = var.subnets.subnet_ids.public
    security_groups = [var.security_groups["default-security-group"].id]
  }

}

resource "aws_ecs_service" "ecs_pgbouncer_service" {
  name            = "${replace(var.tag_version, ".", "-")}-ecs-pgbouncer-service"
  cluster         = var.ecs_cluster.pgbouncer.id
  task_definition = var.ecs_task_definition.pgbouncer.arn
  desired_count   = 1
  launch_type     = "EC2"

  force_new_deployment = true

  placement_constraints {
    type = "distinctInstance"
  }

  service_registries {
    registry_arn = var.pgbouncer_service_discovery_service.arn
  }

  network_configuration {
    subnets         = var.subnets.subnet_ids.public
    security_groups = [var.security_groups["default-security-group"].id]
  }

  depends_on = [aws_ecs_service.ecs_db_service]
}

