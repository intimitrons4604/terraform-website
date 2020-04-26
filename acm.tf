resource "aws_acm_certificate" "website_primary_certificate" {
  provider = aws.us-east-1

  domain_name       = "${var.subdomain}.intimitrons.ca."
  validation_method = "DNS"
}

resource "aws_route53_record" "website_primary_certificate_dns_validation" {
  zone_id = data.terraform_remote_state.dns.outputs.zone_id
  name    = aws_acm_certificate.website_primary_certificate.domain_validation_options[0].resource_record_name
  type    = aws_acm_certificate.website_primary_certificate.domain_validation_options[0].resource_record_type
  ttl     = 300
  records = [aws_acm_certificate.website_primary_certificate.domain_validation_options[0].resource_record_value]
}

resource "aws_acm_certificate_validation" "website_primary_certificate_validation" {
  provider = aws.us-east-1

  certificate_arn         = aws_acm_certificate.website_primary_certificate.arn
  validation_record_fqdns = [aws_route53_record.website_primary_certificate_dns_validation.fqdn]
}
