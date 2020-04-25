output "web_bucket_website_endpoint" {
  value       = aws_s3_bucket.web_bucket.website_endpoint
  description = "The S3 website endpoint for the web bucket"
}
