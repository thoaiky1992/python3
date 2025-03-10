output "pgbouncer" {
  value = {
    id = aws_launch_template.ecs_pgbouncer_launch_template.id
  }
}
output "db" {
  value = {
    id = aws_launch_template.ecs_db_launch_template.id
  }
}
output "api" {
  value = {
    id = aws_launch_template.ecs_api_launch_template.id
  }
}

