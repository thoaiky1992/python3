output "db" {
  value = aws_ecs_service.ecs_db_service
}
output "pgbouncer" {
  value = aws_ecs_service.ecs_pgbouncer_service
}
output "redis" {
  value = aws_ecs_service.ecs_redis_service
}
output "api" {
  value = aws_ecs_service.ecs_api_service
}