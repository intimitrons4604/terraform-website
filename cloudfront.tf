resource "aws_cloudfront_distribution" "web_distribution" {
  enabled = true
  comment = "${var.subdomain}.intimitrons.ca"

  is_ipv6_enabled = true
  http_version    = "http2"
  price_class     = "PriceClass_100"

  viewer_certificate {
    cloudfront_default_certificate = true
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

    viewer_protocol_policy = "allow-all"
    allowed_methods        = ["GET", "HEAD"]
    cached_methods         = ["GET", "HEAD"]

    compress         = false
    smooth_streaming = false

    default_ttl = 60
    min_ttl     = 0
    max_ttl     = 31536000

    forwarded_values {
      cookies {
        forward = "none"
      }
      query_string = false
    }
  }

  tags = {
    "trons:environment" = var.environment
    "trons:service"     = "website"
    "trons:terraform"   = "true"
  }
}
