variable "ecs" {
  type = object({
    api = object({
      cluster_name   = string
      service_name   = string
      log_group_name = string
    }),
    ui = object({
      cluster_name = string
      service_name = string
    })
  })
}

variable "region" {
  type = string
}
