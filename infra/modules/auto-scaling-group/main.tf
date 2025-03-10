resource "aws_autoscaling_group" "ecs_db_auto_scaling_group" {
  name                = "${var.tag_version}-ecs-db-auto-scaling-group"
  vpc_zone_identifier = var.public_subnet_ids
  desired_capacity    = 1
  max_size            = 1
  min_size            = 1

  launch_template {
    id      = var.launch_template.db.id
    version = "$Latest"
  }
}

resource "aws_autoscaling_group" "ecs_pgbouncer_auto_scaling_group" {
  name                = "${var.tag_version}-ecs-pgbouncer-auto-scaling-group"
  vpc_zone_identifier = var.public_subnet_ids
  desired_capacity    = 1
  max_size            = 1
  min_size            = 1

  launch_template {
    id      = var.launch_template.pgbouncer.id
    version = "$Latest"
  }
}

resource "aws_autoscaling_group" "ecs_api_auto_scaling_group" {
  name                = "${var.tag_version}-ecs-api-auto-scaling-group"
  vpc_zone_identifier = var.public_subnet_ids
  desired_capacity    = 1
  min_size            = 1
  max_size            = 10

  launch_template {
    id      = var.launch_template.api.id
    version = "$Latest"
  }
}