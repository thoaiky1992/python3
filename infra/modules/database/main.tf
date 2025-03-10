resource "aws_db_subnet_group" "postgres_dbsg" {
  name       = "${var.tag_version}-main"
  subnet_ids = var.subnet_ids

  tags = {
    Name = "My DB subnet group"
  }
}
# resource "random_string" "db_password" {
#   length  = 16
#   upper   = true
#   lower   = true
#   special = false
# }

locals {
  db_account_info = {
    username = var.database_configs.username
    password = var.database_configs.password
  }
}

resource "aws_ssm_parameter" "secret" {
  for_each    = local.db_account_info
  name        = "/${var.tag_version}/database/${each.key}/master"
  description = "The parameter description"
  type        = "SecureString"
  value       = each.value

  tags = {
    environment = "${var.tag_version}-database/${each.key}/master"
  }
}

resource "aws_db_instance" "postgres_instance" {
  allocated_storage     = 20
  max_allocated_storage = 20
  storage_type          = var.database_configs.storage_type
  engine                = var.database_configs.engine
  engine_version        = var.database_configs.engine_version
  instance_class        = var.database_configs.instance_class
  db_name               = var.database_configs.name
  username              = var.database_configs.username
  # password              = random_string.db_password.result
  password             = var.database_configs.password
  port                 = var.database_configs.port
  parameter_group_name = var.database_configs.parameter_group_name
  skip_final_snapshot  = var.database_configs.skip_final_snapshot
  db_subnet_group_name = aws_db_subnet_group.postgres_dbsg.name
  identifier           = "${replace(var.tag_version, ".", "-")}-postgres-app"
  # backup_retention_period = 7

  # Các thiết lập bảo mật
  publicly_accessible    = var.database_configs.publicly_accessible
  vpc_security_group_ids = [var.security_group_id]

  tags = {
    Name = "${var.tag_version}-postgres"
  }
}

