variable "ecs_cluster" {
  description = "ECS cluster details"
  type        = object({ name = string })
}

variable "ecs_service" {
  description = "The name of the ECS API service"
  type = object({
    db        = object({ name = string })
    pgbouncer = object({ name = string })
    redis     = object({ name = string })
  })
}

variable "tag_version" {
  type = string
}
