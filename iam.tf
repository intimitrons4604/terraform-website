resource "aws_iam_user" "deploy_user" {
  name = "svc_website-deploy-${var.subdomain}"
  tags = {
    "trons:environment" = var.environment
    "trons:service"     = "website"
    "trons:terraform"   = "true"
  }
}

data "aws_iam_policy_document" "deploy_policy" {
  version = "2012-10-17"
  statement {
    effect = "Allow"
    actions = [
      "dynamodb:DeleteItem",
      "dynamodb:GetItem",
      "dynamodb:PutItem",
    ]
    resources = [aws_dynamodb_table.lock_table.arn]
  }
  statement {
    effect = "Allow"
    actions = [
      "s3:ListBucket",
    ]
    resources = [aws_s3_bucket.web_bucket.arn]
  }
  statement {
    effect = "Allow"
    actions = [
      "s3:DeleteObject",
      "s3:PutObject",
    ]
    resources = ["${aws_s3_bucket.web_bucket.arn}/*"]
  }
}

resource "aws_iam_policy" "deploy_policy" {
  name   = "svc_website-deploy-${var.subdomain}"
  policy = data.aws_iam_policy_document.deploy_policy.json
}

resource "aws_iam_user_policy_attachment" "deploy_user_policy" {
  user       = aws_iam_user.deploy_user.name
  policy_arn = aws_iam_policy.deploy_policy.arn
}
