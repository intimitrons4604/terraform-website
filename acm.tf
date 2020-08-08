resource "aws_acm_certificate" "website_primary_certificate" {
  provider = aws.us-east-1

  domain_name       = "${var.subdomain}.${trimsuffix(data.terraform_remote_state.dns.outputs.fqdn, ".")}"
  validation_method = "DNS"

  tags = {
    "trons:environment" = var.environment
    "trons:service"     = "website"
    "trons:terraform"   = "true"
  }
}

resource "aws_route53_record" "website_primary_certificate_dns_validation" {
  for_each = {
    for opt in aws_acm_certificate.website_primary_certificate.domain_validation_options : opt.domain_name => {
      name   = opt.resource_record_name
      type   = opt.resource_record_type
      record = opt.resource_record_value
    }
  }

  zone_id = data.terraform_remote_state.dns.outputs.zone_id
  name    = each.value.name
  type    = each.value.type
  ttl     = 300
  records = [each.value.record]
}

resource "aws_acm_certificate_validation" "website_primary_certificate_validation" {
  provider = aws.us-east-1

  certificate_arn         = aws_acm_certificate.website_primary_certificate.arn
  validation_record_fqdns = [for record in aws_route53_record.website_primary_certificate_dns_validation : record.fqdn]
}
