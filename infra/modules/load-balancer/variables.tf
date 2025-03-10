variable "security_groups" {
  type        = any
}

variable "subnet_ids" {
  type        = object({
    public = list(string)
    private = list(string)
  })
}

variable "vpc_id" {
  description = "The VPC ID where the load balancer and target group will be deployed"
  type        = string
}
variable "tag_version" {
  type = string
}