variable "ecs_cluster" {
  description = "ECS cluster details"
  type = object({
    db = object({ id = string, name = string })
    redis = object({ id = string, name = string })
    api = object({ id = string, name = string })
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

variable "cloud_map" {
  type = object({
    aws_service_discovery_http_namespace = object({
      arn = string
    })
  })
}
variable "lb_target_groups" {
  type = object({
    api = object({
      arn =  string
    })
  })
}

