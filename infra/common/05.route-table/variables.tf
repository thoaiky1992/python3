variable "vpc_id" {
  type = string
}
variable "igw_id" {
  type = string
}
variable "nat_id" {
  type = string
}
variable "subnet_ids" {
  type = object({
    public = list(string)
    private = list(string)
  })
}
variable "environment" {
  type = string
}