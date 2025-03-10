output "db" {
  value = {
    arn  = aws_ecs_task_definition.ecs_db_task_definition.arn
    log_group_name = aws_cloudwatch_log_group.ecs_db_log_group.name
  }
}

output "pgbouncer" {
  value = {
    arn  = aws_ecs_task_definition.ecs_pgbouncer_task_definition.arn
    log_group_name = aws_cloudwatch_log_group.ecs_pgbouncer_log_group.name
  }
}