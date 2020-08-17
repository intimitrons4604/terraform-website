output "web_bucket_name" {
  value       = aws_s3_bucket.web_bucket.id
  description = "The name of the S3 bucket for website content"
}

output "web_distribution_id" {
  value       = aws_cloudfront_distribution.web_distribution.id
  description = "The ID of the CloudFront distribution for the website"
}

output "lock_table_name" {
  value       = aws_dynamodb_table.lock_table.id
  description = "The name of the DynamoDB table for locks"
}

output "log_bucket_name" {
  value       = aws_s3_bucket.log_bucket.id
  description = "The name of the S3 bucket for access logs"
}
