# Create the ACM certificate with DNS validation
resource "aws_acm_certificate" "new_cert" {
  count             = length(var.domain_names)
  domain_name       = var.domain_names[count.index]
  validation_method = "DNS"
  lifecycle {
    create_before_destroy = true
  }
}

# Retrieve the Route 53 hosted zone
data "aws_route53_zone" "selected_zone" {
  for_each     = toset(var.domain_names)
  name         = each.key
  private_zone = false
}

# Create Route 53 DNS records for validation
resource "aws_route53_record" "cert_validation" {
  for_each = {
    for cert in aws_acm_certificate.new_cert : cert.domain_name => tolist(cert.domain_validation_options)
  }

  zone_id = data.aws_route53_zone.selected_zone[each.key].zone_id
  name    = each.value[0].resource_record_name
  type    = each.value[0].resource_record_type
  records = [each.value[0].resource_record_value]
  ttl     = 60
}

# Validate the ACM certificates
resource "aws_acm_certificate_validation" "cert_validation" {
  count                   = length(var.domain_names)
  certificate_arn         = aws_acm_certificate.new_cert[count.index].arn
  validation_record_fqdns = [aws_route53_record.cert_validation[var.domain_names[count.index]].fqdn]
}
