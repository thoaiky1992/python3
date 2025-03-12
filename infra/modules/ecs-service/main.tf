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

  # service_registries {
  #   registry_arn = var.service_discovery.db_service_discovery_service.arn
  # }

  service_connect_configuration {
    enabled   = true
    namespace = var.cloud_map.aws_service_discovery_http_namespace.arn
    service {
      discovery_name = "db"
      port_name      = "db_port"
      client_alias {
        dns_name = "db"
        port     = 5432
      }
    }
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

  # service_registries {
  #   registry_arn = var.service_discovery.pgbouncer_service_discovery_service.arn
  # }
  service_connect_configuration {
    enabled   = true
    namespace = var.cloud_map.aws_service_discovery_http_namespace.arn
    service {
      discovery_name = "pgbouncer"
      port_name      = "pgbouncer_port"
      client_alias {
        dns_name = "pgbouncer"
        port     = 6432
      }
    }
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

  # service_registries {
  #   registry_arn = var.service_discovery.redis_service_discovery_service.arn
  # }
  service_connect_configuration {
    enabled   = true
    namespace = var.cloud_map.aws_service_discovery_http_namespace.arn
    service {
      discovery_name = "redis"
      port_name      = "redis_port"
      client_alias {
        dns_name = "redis"
        port     = 6379
      }
    }
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

  # service_registries {
  #   registry_arn = var.service_discovery.api_service_discovery_service.arn
  # }
  service_connect_configuration {
    enabled   = true
    namespace = var.cloud_map.aws_service_discovery_http_namespace.arn
    service {
      discovery_name = "api"
      port_name      = "api_port"
      client_alias {
        dns_name = "api"
        port     = 4000
      }
    }
  }

  network_configuration {
    subnets         = var.subnets.subnet_ids.private
    security_groups = [var.security_groups["api-security-group"].id]
  }

  load_balancer {
    target_group_arn = var.lb_target_groups.api.arn
    container_name   = "api"
    container_port   = 4000
  }

  depends_on = [aws_ecs_service.ecs_pgbouncer_service, aws_ecs_service.ecs_redis_service]
}

