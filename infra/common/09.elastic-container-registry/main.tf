resource "aws_ecr_repository" "ecr_api" {
  name                 = "${var.environment}-api"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = false
  }

  lifecycle {
    prevent_destroy = false
    ignore_changes  = [name]
  }

  force_delete = true
}
