resource "aws_iam_user" "cicd_user" {
  name = "${var.domain_name}-cicd-user"
  path = "/cicd/"

  tags = merge(var.tags, {
    Name        = "CI/CD User for ${var.domain_name}"
    Purpose     = "GitHub Actions deployment"
    Environment = "Production"
  })
}

data "aws_iam_policy_document" "cicd_policy" {
  statement {
    sid    = "S3BucketAccess"
    effect = "Allow"
    actions = [
      "s3:GetBucketLocation",
      "s3:ListBucket"
    ]
    resources = [aws_s3_bucket.site.arn]
  }

  statement {
    sid    = "S3ObjectAccess"
    effect = "Allow"
    actions = [
      "s3:GetObject",
      "s3:PutObject",
      "s3:DeleteObject",
      "s3:PutObjectAcl"
    ]
    resources = ["${aws_s3_bucket.site.arn}/*"]
  }

  statement {
    sid    = "CloudFrontInvalidation"
    effect = "Allow"
    actions = [
      "cloudfront:CreateInvalidation",
      "cloudfront:GetInvalidation",
      "cloudfront:ListInvalidations"
    ]
    resources = [aws_cloudfront_distribution.this.arn]
  }
}

resource "aws_iam_policy" "cicd_policy" {
  name        = "${var.domain_name}-cicd-policy"
  description = "Policy for CI/CD deployment to ${var.domain_name}"
  policy      = data.aws_iam_policy_document.cicd_policy.json

  tags = merge(var.tags, {
    Name        = "CI/CD Policy for ${var.domain_name}"
    Purpose     = "GitHub Actions deployment"
    Environment = "Production"
  })
}

resource "aws_iam_user_policy_attachment" "cicd_policy_attachment" {
  user       = aws_iam_user.cicd_user.name
  policy_arn = aws_iam_policy.cicd_policy.arn
}

resource "aws_iam_access_key" "cicd_access_key" {
  user = aws_iam_user.cicd_user.name
}
