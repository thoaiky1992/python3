output "api" {
  value = {
    url = aws_ecr_repository.ecr_api.repository_url
  }
}
