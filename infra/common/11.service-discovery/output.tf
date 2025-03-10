output "aws_service_discovery_private_dns_namespace" {
  value = aws_service_discovery_private_dns_namespace.main
}
output "db_service_discovery_service" {
  value = aws_service_discovery_service.postgres
}
output "pgbouncer_service_discovery_service" {
  value = aws_service_discovery_service.pgbouncer
}
output "api_service_discovery_service" {
  value = aws_service_discovery_service.api
}