resource "aws_ecs_cluster" "ecs_cluster" {
  name = "${replace(var.tag_version, ".", "-")}-ecs-cluster"
}
