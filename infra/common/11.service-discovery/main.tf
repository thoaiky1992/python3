resource "aws_service_discovery_private_dns_namespace" "main" {
  name        = "${var.environment}-service-discovery"
  description = "Discovery Service"
  vpc         = var.vpc_id
  tags = {
    "Source" = "common/11.service-discovery"
  }
}

resource "aws_service_discovery_service" "postgres" {
  name         = "postgres"
  namespace_id = aws_service_discovery_private_dns_namespace.main.id

  dns_config {
    namespace_id = aws_service_discovery_private_dns_namespace.main.id

    dns_records {
      type = "A"
      ttl  = 10
    }

    routing_policy = "MULTIVALUE"
  }

  health_check_custom_config {
    failure_threshold = 1
  }
}
resource "aws_service_discovery_service" "pgbouncer" {
  name         = "pgbouncer"
  namespace_id = aws_service_discovery_private_dns_namespace.main.id

  dns_config {
    namespace_id = aws_service_discovery_private_dns_namespace.main.id

    dns_records {
      type = "A"
      ttl  = 10
    }

    routing_policy = "MULTIVALUE"
  }

  health_check_custom_config {
    failure_threshold = 1
  }
}

resource "aws_service_discovery_service" "api" {
  name         = "api"
  namespace_id = aws_service_discovery_private_dns_namespace.main.id

  dns_config {
    namespace_id = aws_service_discovery_private_dns_namespace.main.id

    dns_records {
      type = "A"
      ttl  = 10
    }

    routing_policy = "MULTIVALUE"
  }

  health_check_custom_config {
    failure_threshold = 1
  }
}
resource "aws_service_discovery_service" "redis" {
  name         = "redis"
  namespace_id = aws_service_discovery_private_dns_namespace.main.id

  dns_config {
    namespace_id = aws_service_discovery_private_dns_namespace.main.id

    dns_records {
      type = "A"
      ttl  = 10
    }

    routing_policy = "MULTIVALUE"
  }

  health_check_custom_config {
    failure_threshold = 1
  }
}