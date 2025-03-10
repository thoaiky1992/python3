variable "ecs_cluster" {
  description = "ECS cluster details"
  type = object({
    db = object({
      name = string
    })
  })
}

variable "ecs_service" {
  description = "The name of the ECS API service"
  type = object({
    db = object({
      name = string
    })
  })
}

variable "tag_version" {
  type = string
}
