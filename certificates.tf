data "aws_route53_zone" "this" {
  count   = var.use_external_dns ? 0 : 1
  zone_id = var.hosted_zone_id
}

resource "aws_acm_certificate" "this" {
  domain_name       = var.domain_name
  validation_method = "DNS"

  tags = merge(var.tags, {
    Name        = "SSL Certificate for ${var.domain_name}"
    Purpose     = "SSL/TLS certificate for website"
    Environment = "Production"
  })
}

resource "aws_route53_record" "cert_validation" {
  for_each = var.use_external_dns ? {} : {
    for dvo in aws_acm_certificate.this.domain_validation_options : dvo.domain_name => {
      name  = dvo.resource_record_name
      type  = dvo.resource_record_type
      value = dvo.resource_record_value
    }
  }
  zone_id = data.aws_route53_zone.this[0].zone_id
  name    = each.value.name
  type    = each.value.type
  ttl     = 60
  records = [each.value.value]
}

resource "aws_acm_certificate_validation" "this" {
  count                   = var.use_external_dns ? 0 : 1
  certificate_arn         = aws_acm_certificate.this.arn
  validation_record_fqdns = [for r in aws_route53_record.cert_validation : r.fqdn]
}
