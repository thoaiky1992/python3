output "ecs_instance_role" {
  value = {
    profile_name = aws_iam_instance_profile.ecs_instance_profile.name
  }
}

output "ecs_task_execution_role" {
  value = {
    arn = aws_iam_role.ecs_task_execution_role.arn
  }
}
