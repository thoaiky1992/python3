output "db" {
  value = { id = aws_ecs_cluster.ecs_db_cluster.id, name = aws_ecs_cluster.ecs_db_cluster.name }
}
output "redis" {
  value = { id = aws_ecs_cluster.ecs_redis_cluster.id, name = aws_ecs_cluster.ecs_redis_cluster.name }
}
output "api" {
  value = { id = aws_ecs_cluster.ecs_api_cluster.id, name = aws_ecs_cluster.ecs_api_cluster.name }
}
