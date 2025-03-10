/*
  CIDR /16 tương đương với 65,536 địa chỉ IP (từ 10.0.0.0 đến 10.0.255.255).
*/
variable "vpc_cidr" {
  description = "The CIDR block for the VPC"
  type        = string
}
variable "environment" {
  type = string
}
