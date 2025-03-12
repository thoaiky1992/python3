variable "ami_id" {
  description = "The AMI ID for the ECS instances"
  type        = string
  default     = "ami-02865bbb5ac96158d"
}

variable "instance_type" {
  description = "The instance type for the ECS instances"
  type        = string
  default     = "t2.small"
}

variable "key_pair_name" {
  description = "The key pair name to use for SSH access to the ECS instances"
  type        = string
}

variable "security_groups" {
  description = "Security groups for the ECS instances"
  type        = any
}

variable "ecs_instance_role_profile_name" {
  description = "The IAM instance profile name for the ECS instances"
  type        = string
}

variable "ecs_cluster" {
  type = object({
    db        = object({ id = string, name = string })
    redis     = object({ id = string, name = string })
    api       = object({ id = string, name = string })
  })
}
variable "tag_version" {
  type = string
}


variable "public_subnet_ids" {
  type = list(string)
}

variable "private_subnet_ids" {
  type = list(string)
}
