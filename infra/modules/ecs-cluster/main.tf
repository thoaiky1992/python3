resource "aws_ecs_cluster" "ecs_db_cluster" {
  name = "${replace(var.tag_version, ".", "-")}-ecs-db-cluster"
}
resource "aws_ecs_cluster" "ecs_redis_cluster" {
  name = "${replace(var.tag_version, ".", "-")}-ecs-redis-cluster"
}
resource "aws_ecs_cluster" "ecs_api_cluster" {
  name = "${replace(var.tag_version, ".", "-")}-ecs-api-cluster"
}
