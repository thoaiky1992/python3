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
    registry_arn = var.service_discovery.db_service_discovery_service.arn
  }

  network_configuration {
    subnets         = var.subnets.subnet_ids.private
    security_groups = [var.security_groups["postgres-security-group"].id]
  }

}

resource "aws_ecs_service" "ecs_pgbouncer_service" {
  name            = "${replace(var.tag_version, ".", "-")}-ecs-pgbouncer-service"
  cluster         = var.ecs_cluster.db.id
  task_definition = var.ecs_task_definition.pgbouncer.arn
  desired_count   = 1
  launch_type     = "EC2"

  force_new_deployment = true

  placement_constraints {
    type = "distinctInstance"
  }

  service_registries {
    registry_arn = var.service_discovery.pgbouncer_service_discovery_service.arn
  }

  network_configuration {
    subnets         = var.subnets.subnet_ids.private
    security_groups = [var.security_groups["pgbouncer-security-group"].id]
  }

  depends_on = [aws_ecs_service.ecs_db_service]
}

resource "aws_ecs_service" "ecs_redis_service" {
  name            = "${replace(var.tag_version, ".", "-")}-ecs-redis-service"
  cluster         = var.ecs_cluster.redis.id
  task_definition = var.ecs_task_definition.redis.arn
  desired_count   = 1
  launch_type     = "EC2"

  force_new_deployment = true

  placement_constraints {
    type = "distinctInstance"
  }

  service_registries {
    registry_arn = var.service_discovery.redis_service_discovery_service.arn
  }

  network_configuration {
    subnets         = var.subnets.subnet_ids.private
    security_groups = [var.security_groups["redis-security-group"].id]
  }

}

resource "aws_ecs_service" "ecs_api_service" {
  name            = "${replace(var.tag_version, ".", "-")}-ecs-api-service"
  cluster         = var.ecs_cluster.api.id
  task_definition = var.ecs_task_definition.api.arn
  desired_count   = 2
  launch_type     = "EC2"

  force_new_deployment = true

  # placement_constraints {
  #   type = "distinctInstance"
  # }

  service_registries {
    registry_arn = var.service_discovery.api_service_discovery_service.arn
  }

  network_configuration {
    subnets         = var.subnets.subnet_ids.public
    security_groups = [var.security_groups["default-security-group"].id]
  }

  load_balancer {
    target_group_arn = var.lb_target_groups.api.arn
    container_name   = "api"
    container_port   = 4000
  }

  depends_on = [aws_ecs_service.ecs_pgbouncer_service, aws_ecs_service.ecs_redis_service]
}

