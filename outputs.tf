output "bucket_name" {
  value = aws_s3_bucket.site.bucket
}

output "cloudfront_domain_name" {
  value = aws_cloudfront_distribution.this.domain_name
}

output "cloudfront_distribution_id" {
  value = aws_cloudfront_distribution.this.id
}

# CI/CD User outputs
output "cicd_user_name" {
  value = aws_iam_user.cicd_user.name
  description = "Name of the CI/CD IAM user"
}

output "cicd_access_key_id" {
  value = aws_iam_access_key.cicd_access_key.id
  description = "Access Key ID for CI/CD user"
  sensitive = true
}

output "cicd_secret_access_key" {
  value = aws_iam_access_key.cicd_access_key.secret
  description = "Secret Access Key for CI/CD user"
  sensitive = true
}

output "cicd_policy_arn" {
  value = aws_iam_policy.cicd_policy.arn
  description = "ARN of the CI/CD policy"
}


