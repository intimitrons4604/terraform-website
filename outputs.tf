output "deploy_policy_arn" {
  value       = aws_iam_policy.deploy_policy.arn
  description = "The ARN of the IAM policy permitting deployment of the website"
}

output "lock_table_arn" {
  value       = aws_dynamodb_table.lock_table.arn
  description = "The ARN of the DynamoDB table for locks"
}

output "log_bucket_arn" {
  value       = aws_s3_bucket.log_bucket.arn
  description = "The ARN of the S3 bucket for access logs"
}

output "web_bucket_arn" {
  value       = aws_s3_bucket.web_bucket.arn
  description = "The ARN of the S3 bucket for website content"
}

output "web_distribution_arn" {
  value       = aws_cloudfront_distribution.web_distribution.arn
  description = "The ARN of the CloudFront distribution for the website"
}
