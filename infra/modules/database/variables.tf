variable "subnet_ids" {
  description = "List of subnet IDs for the DB subnet group"
  type        = list(string)
}

variable "security_group_id" {
  description = "The security group ID to associate with the RDS instance"
  type        = string
}

variable "database_configs" {
  description = "Configuration for the RDS instance"
  type = object({
    storage_type         = string
    engine               = string
    engine_version       = string
    instance_class       = string
    name                 = string
    username             = string
    password             = string
    port                 = number
    parameter_group_name = string
    skip_final_snapshot  = bool
    publicly_accessible  = bool
  })
}
variable "tag_version" {
  type = string 
}
