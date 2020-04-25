resource "aws_s3_bucket" "web_bucket" {
  bucket = "trons-website-web-${var.subdomain}"
  website {
    index_document = "index.html"
    error_document = "404.html"
  }
  lifecycle_rule {
    enabled                                = true
    abort_incomplete_multipart_upload_days = 1
  }
  tags = {
    "trons:environment" = var.environment
    "trons:service"     = "website"
    "trons:terraform"   = "true"
  }
}

resource "aws_s3_bucket_public_access_block" "web_bucket_public_access_block" {
  bucket                  = aws_s3_bucket.web_bucket.id
  block_public_acls       = true
  block_public_policy     = false
  ignore_public_acls      = true
  restrict_public_buckets = false
}

data "aws_iam_policy_document" "allow_public_get_bucket_policy" {
  version = "2012-10-17"
  statement {
    sid    = "AllowPublicGet"
    effect = "Allow"
    principals {
      type        = "AWS"
      identifiers = ["*"]
    }
    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.web_bucket.arn}/*"]
  }
}

resource "aws_s3_bucket_policy" "web_bucket_policy" {
  bucket = aws_s3_bucket.web_bucket.id
  policy = data.aws_iam_policy_document.allow_public_get_bucket_policy.json

  depends_on = [aws_s3_bucket_public_access_block.web_bucket_public_access_block]
}
