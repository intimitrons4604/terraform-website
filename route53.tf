resource "aws_route53_record" "website_primary" {
  for_each = {
    v4 = "A"
    v6 = "AAAA"
  }

  zone_id = data.terraform_remote_state.dns.outputs.zone_id
  name    = var.subdomain
  type    = each.value

  alias {
    name                   = aws_cloudfront_distribution.web_distribution.domain_name
    zone_id                = aws_cloudfront_distribution.web_distribution.hosted_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "website_redirect" {
  zone_id = data.terraform_remote_state.dns.outputs.zone_id
  name    = "www.${var.subdomain}"
  type    = "A"

  alias {
    name                   = aws_s3_bucket.redirect_bucket.website_domain
    zone_id                = aws_s3_bucket.redirect_bucket.hosted_zone_id
    evaluate_target_health = false
  }
}
