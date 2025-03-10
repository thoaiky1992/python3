variable "ecs_task_execution_role" {
  description = "The ARN of the IAM role that allows ECS tasks to make calls to AWS services"
  type = object({
    arn = string
  })
}

variable "region" {
  description = "The AWS region where the resources will be created"
  type        = string
  default     = "ap-southeast-1"
}
variable "tag_version" {
  type = string
}
