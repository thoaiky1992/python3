variable "ecs_cluster" {
  description = "ECS cluster details"
  type = object({
    db        = object({ id = string, name = string })
    pgbouncer = object({ id = string, name = string })
    redis     = object({ id = string, name = string })
    api       = object({ id = string, name = string })
  })
}

variable "ecs_task_definition" {
  description = "ECS task definition details"
  type = object({
    db        = object({ arn = string })
    pgbouncer = object({ arn = string })
    redis     = object({ arn = string })
    api       = object({ arn = string })
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

variable "service_discovery" {
  type = object({
    db_service_discovery_service        = object({ arn = string })
    pgbouncer_service_discovery_service = object({ arn = string })
    redis_service_discovery_service     = object({ arn = string })
    api_service_discovery_service       = object({ arn = string })
  })
}
