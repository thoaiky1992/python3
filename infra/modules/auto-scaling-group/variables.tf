variable "private_subnet_ids" {
  description = "List of private subnet IDs for the ECS API auto scaling group"
  type        = list(string)
}

variable "public_subnet_ids" {
  description = "List of public subnet IDs for the ECS UI auto scaling group"
  type        = list(string)
}

variable "launch_template" {
  description = "Launch templates for the ECS pgbouncer and Api"
  type = object({
    db        = object({ id = string })
    api       = object({ id = string })
    redis     = object({ id = string })
  })
}
variable "tag_version" {
  type = string
}

