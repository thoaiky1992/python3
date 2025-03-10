resource "aws_cloudwatch_log_group" "ecs_db_log_group" {
  name              = "${var.tag_version}/ecs/ecs-db-task"
  retention_in_days = 7
}
resource "aws_ecs_task_definition" "ecs_db_task_definition" {
  family             = "${replace(var.tag_version, ".", "-")}-ecs-db-task"
  network_mode       = "awsvpc"
  execution_role_arn = var.ecs_task_execution_role.arn
  cpu                = 256
  memory             = 512

  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "X86_64"
  }

  volume {
    name      = "postgres-data"
    host_path = "/mnt/postgres-data/pgdata"
  }

  container_definitions = jsonencode([
    {
      name      = "db"
      image     = "postgres:15.2-alpine"
      cpu       = 256
      memory    = 512
      essential = true

      mountPoints = [
        {
          sourceVolume  = "postgres-data"
          containerPath = "/var/lib/postgresql/data"
          readOnly      = false
        }
      ]

      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = aws_cloudwatch_log_group.ecs_db_log_group.name
          "awslogs-region"        = var.region
          "awslogs-stream-prefix" = var.tag_version
        }
      }
      portMappings = [
        {
          containerPort = 5432
          hostPort      = 5432
          protocol      = "tcp"
          name          = "db-port"
        }
      ]
      environment = [
        {
          name  = "POSTGRES_USER"
          value = "dev"
        },
        {
          name  = "POSTGRES_PASSWORD"
          value = "ior2023"
        },
        {
          name  = "POSTGRES_DB"
          value = "python"
        },
        {
          name  = "POSTGRES_INITDB_ARGS"
          value = "--encoding=UTF-8"
        },
      ]
      command = [
        "postgres",
        "-c",
        "log_destination=stderr",
        "-c",
        "log_statement=all",
        "-c",
        "log_connections=on",
        "-c",
        "log_disconnections=on"
      ]
    }
  ])

  depends_on = [aws_cloudwatch_log_group.ecs_db_log_group]
}

resource "aws_cloudwatch_log_group" "ecs_pgbouncer_log_group" {
  name              = "${var.tag_version}/ecs/ecs-pgbouncer-task"
  retention_in_days = 7
}
resource "aws_ecs_task_definition" "ecs_pgbouncer_task_definition" {
  family             = "${replace(var.tag_version, ".", "-")}-ecs-pgbouncer-task"
  network_mode       = "awsvpc"
  execution_role_arn = var.ecs_task_execution_role.arn
  cpu                = 256
  memory             = 512

  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "X86_64"
  }

  volume {
    name      = "pgbouncer-data"
    host_path = "/home/ec2-user/pgbouncer-data/userlist.txt"
  }

  container_definitions = jsonencode([
    {
      name      = "pgbouncer"
      image     = "bitnami/pgbouncer"
      cpu       = 256
      memory    = 512
      essential = true

      mountPoints = [
        {
          sourceVolume  = "pgbouncer-data"
          containerPath = "/bitnami/userlist.txt"
          readOnly      = false
        }
      ]

      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = aws_cloudwatch_log_group.ecs_pgbouncer_log_group.name
          "awslogs-region"        = var.region
          "awslogs-stream-prefix" = var.tag_version
        }
      }
      portMappings = [
        {
          containerPort = 6432
          hostPort      = 6432
          protocol      = "tcp"
        }
      ]

      environment = [
        {
          name  = "POSTGRESQL_HOST"
          value = "postgres.dev-service-discovery"
        },
        {
          name  = "POSTGRESQL_PASSWORD"
          value = "ior2023"
        },
        {
          name  = "POSTGRESQL_DATABASE"
          value = "python"
        },
        {
          name  = "PGBOUNCER_AUTH_TYPE"
          value = "trust"
        },
         {
          name  = "PGBOUNCER_USERLIST_FILE"
          value = "/bitnami/userlist.txt"
        },
         {
          name  = "PGBOUNCER_DSN_0"
          value = "python=host=postgres.dev-service-discovery port=5432 dbname=python"
        },
      ]
    }
  ])

  depends_on = [aws_cloudwatch_log_group.ecs_pgbouncer_log_group]
}