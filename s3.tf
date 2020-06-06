resource "aws_s3_bucket" "web_bucket" {
  // The HTTPS certificate will not match bucket names with periods when using the virtual-hosted–style URI (e.g. bucket.s3.amazonaws.com)
  bucket = "trons-website-web-${replace(var.subdomain, ".", "-")}"
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

resource "aws_s3_bucket" "redirect_bucket" {
  // The HTTPS certificate will not match bucket names with periods when using the virtual-hosted–style URI (e.g. bucket.s3.amazonaws.com)
  bucket = "trons-website-redirect-${replace(var.subdomain, ".", "-")}"
  website {
    redirect_all_requests_to = "https://${var.subdomain}.${trimsuffix(data.terraform_remote_state.dns.outputs.fqdn, ".")}/"
  }
  tags = {
    "trons:environment" = var.environment
    "trons:service"     = "website"
    "trons:terraform"   = "true"
  }
}

data "aws_iam_policy_document" "deny_put_bucket_policy" {
  version = "2012-10-17"
  statement {
    sid    = "DenyPut"
    effect = "Deny"
    principals {
      type        = "AWS"
      identifiers = ["*"]
    }
    actions   = ["s3:PutObject"]
    resources = ["${aws_s3_bucket.redirect_bucket.arn}/*"]
  }
}

resource "aws_s3_bucket_policy" "redirect_bucket_policy" {
  bucket = aws_s3_bucket.redirect_bucket.id
  policy = data.aws_iam_policy_document.deny_put_bucket_policy.json
}
