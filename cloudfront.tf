resource "aws_cloudfront_distribution" "web_distribution" {
  enabled = true

  is_ipv6_enabled = true
  http_version    = "http2"
  price_class     = "PriceClass_100"

  aliases = ["${var.subdomain}.${trimsuffix(data.terraform_remote_state.dns.outputs.fqdn, ".")}"]

  viewer_certificate {
    acm_certificate_arn      = aws_acm_certificate.website_primary_certificate.arn
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2018"
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  origin {
    origin_id   = "default"
    domain_name = aws_s3_bucket.web_bucket.website_endpoint

    custom_origin_config {
      origin_protocol_policy = "http-only"
      http_port              = 80

      origin_read_timeout      = 10
      origin_keepalive_timeout = 5

      // These values are required but should be unused due to the origin_protocol_policy
      https_port           = 443
      origin_ssl_protocols = ["TLSv1.2"]
    }
  }

  default_cache_behavior {
    target_origin_id = "default"

    viewer_protocol_policy = "redirect-to-https"
    allowed_methods        = ["GET", "HEAD"]
    cached_methods         = ["GET", "HEAD"]

    compress         = true
    smooth_streaming = false

    default_ttl = 86400
    min_ttl     = 0
    max_ttl     = 31536000

    forwarded_values {
      cookies {
        forward = "none"
      }
      query_string = false
    }
  }

  logging_config {
    bucket = aws_s3_bucket.log_bucket.bucket_regional_domain_name
    prefix = "cloudFront/"
  }

  tags = {
    "trons:environment" = var.environment
    "trons:service"     = "website"
    "trons:terraform"   = "true"
  }

  depends_on = [aws_acm_certificate_validation.website_primary_certificate_validation]
}
