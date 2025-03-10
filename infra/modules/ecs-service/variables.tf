variable "ecs_cluster" {
  description = "ECS cluster details"
  type = object({
    db = object({
      id = string
    })
    pgbouncer = object({
      id = string
    })
  })
}

variable "ecs_task_definition" {
  description = "ECS task definition details"
  type = object({
    db = object({
      arn = string
    })
    pgbouncer = object({
      arn = string
    })
  })
}
variable "tag_version" {
  type = string
}

variable "subnets" {
  type = object({
    subnet_ids = object({
      public  = list(string),
      private = list(string)
    })
  })
}

variable "security_groups" {
  type = any
}

variable "db_service_discovery_service" {
  type = object({
    arn = string
  })
}
variable "pgbouncer_service_discovery_service" {
  type = object({
    arn = string
  })
}
