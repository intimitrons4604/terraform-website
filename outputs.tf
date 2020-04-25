output "web_bucket_website_endpoint" {
  value       = aws_s3_bucket.web_bucket.website_endpoint
  description = "The S3 website endpoint for the web bucket"
}

output "web_distribution_domain_name" {
  value       = aws_cloudfront_distribution.web_distribution.domain_name
  description = "The domain name of the CloudFront distribution"
}
