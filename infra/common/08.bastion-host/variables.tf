variable "ami_id" {
  description = "The AMI ID for the bastion host"
  type        = string
  default     = "ami-06650ca7ed78ff6fa" // Canonical, Ubuntu, 24.04, amd64 noble image (region: Singapore)
}

variable "instance_type" {
  description = "The instance type for the bastion host"
  type        = string
  default     = "t2.small"
}

variable "subnet_id" {
  description = "The subnet ID where the bastion host will be deployed"
  type        = string
}

variable "security_group_id" {
  description = "The security group ID to associate with the bastion host"
  type        = string
}

variable "key_name" {
  description = "The key pair name to use for SSH access to the bastion host"
  type        = string
}
variable "environment" {
  type = string
}
variable "region" {
  type = string
}
