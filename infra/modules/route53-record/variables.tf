variable "domain_name" {
  description = "The domain name to create the record for"
  type = string
}
variable "load_balancer_zone_id" {
  description = "The zone id of the load balancer"
  type = string
}
variable "load_balancer_dns_name" {
  description = "The DNS name of the load balancer"
  type = string
}
variable "key_pair_pem" {
  type = string
}
variable "tag_version" {
  type = string
}