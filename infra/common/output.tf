output "vpc" {
  value = module.vpc
}

output "iam_role" {
  value = module.iam_role
}

output "subnets" {
  value = module.subnets
}

output "igw" {
  value = module.igw
}

output "nat" {
  value = module.nat
}

output "security_groups" {
  value = module.security_group.list
}

output "bastion_host" {
  value = module.bastion_host
}

output "ecr" {
  value = module.ecr
}
output "service_discovery" {
  value = {
    aws_service_discovery_private_dns_namespace = module.service_discovery.aws_service_discovery_private_dns_namespace
    db_service_discovery_service                = module.service_discovery.db_service_discovery_service
    pgbouncer_service_discovery_service         = module.service_discovery.pgbouncer_service_discovery_service
    api_service_discovery_service               = module.service_discovery.api_service_discovery_service
    redis_service_discovery_service             = module.service_discovery.redis_service_discovery_service
  }
}

