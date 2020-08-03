resource "aws_dynamodb_table" "lock_table" {
  name = "trons-website-lock-${var.subdomain}"

  // Only provisioned tables are included in the free tier
  billing_mode   = "PROVISIONED"
  read_capacity  = 1
  write_capacity = 1

  hash_key = "id"
  attribute {
    name = "id"
    type = "S"
  }

  tags = {
    "trons:environment" = var.environment
    "trons:service"     = "website"
    "trons:terraform"   = "true"
  }
}
