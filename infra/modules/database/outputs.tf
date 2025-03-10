output "address" {
  value = aws_db_instance.postgres_instance.address
}
# output "password" {
#   value = random_string.db_password.result
# }