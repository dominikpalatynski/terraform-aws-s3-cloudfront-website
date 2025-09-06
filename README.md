# Terraform AWS Static Website Module

This module creates a complete static website hosting infrastructure on AWS using S3, CloudFront, Route 53, and SSL certificates.

## Features

- ✅ S3 bucket for static website hosting
- ✅ CloudFront CDN for global content delivery
- ✅ SSL certificate with automatic DNS validation
- ✅ Route 53 DNS records (A and AAAA)
- ✅ IAM user for CI/CD deployments
- ✅ IPv6 support
- ✅ HTTPS redirect
- ✅ Custom error pages

## Usage

### Basic Example

```hcl
module "static_website" {
  source = "github.com/your-username/terraform-aws-static-website"

  domain_name      = "example.com"
  hosted_zone_id   = "Z1234567890ABC"
}
```

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.0 |
| aws | ~> 5.0 |

## Providers

| Name | Version |
|------|---------|
| aws | ~> 5.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| domain_name | The domain name for the website | `string` | n/a | yes |
| hosted_zone_id | The Route 53 hosted zone ID | `string` | n/a | yes |
| tags | Additional tags to apply to resources | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| bucket_name | Name of the S3 bucket |
| cloudfront_domain_name | CloudFront distribution domain name |
| cloudfront_distribution_id | CloudFront distribution ID |
| cicd_user_name | Name of the CI/CD IAM user |
| cicd_access_key_id | Access Key ID for CI/CD user |
| cicd_secret_access_key | Secret Access Key for CI/CD user |
| cicd_policy_arn | ARN of the CI/CD policy |

## CI/CD Integration

The module creates an IAM user with appropriate permissions for CI/CD deployments. This section describes how to set up a complete deployment pipeline.

### IAM User Permissions

The module creates a dedicated IAM user with the following permissions:
- **S3 Bucket Access**: List bucket contents and manage objects
- **S3 Object Operations**: Get, put, delete objects and manage ACLs
- **CloudFront Invalidation**: Create and manage cache invalidations

### Complete GitHub Actions Pipeline

Here's a comprehensive CI/CD pipeline that builds, tests, and deploys your static website:

```yaml
name: Deploy Static Website

on:
  push:
    branches: [ main ]
  pull_request:
    branches: [ main ]

jobs:
  build-and-test:
    runs-on: ubuntu-latest
    
    steps:
    - name: Checkout code
      uses: actions/checkout@v4

    - name: Setup Node.js
      uses: actions/setup-node@v4
      with:
        node-version: '18'
        cache: 'npm'

    - name: Install dependencies
      run: npm ci

    - name: Run tests
      run: npm test

    - name: Build website
      run: npm run build

    - name: Upload build artifacts
      uses: actions/upload-artifact@v4
      with:
        name: website-build
        path: dist/

  deploy:
    needs: build-and-test
    runs-on: ubuntu-latest
    if: github.ref == 'refs/heads/main'
    
    steps:
    - name: Checkout code
      uses: actions/checkout@v4

    - name: Download build artifacts
      uses: actions/download-artifact@v4
      with:
        name: website-build
        path: dist/

    - name: Configure AWS credentials
      uses: aws-actions/configure-aws-credentials@v4
      with:
        aws-access-key-id: ${{ secrets.AWS_ACCESS_KEY_ID }}
        aws-secret-access-key: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
        aws-region: us-east-1

    - name: Deploy to S3
      run: |
        aws s3 sync ./dist s3://${{ secrets.S3_BUCKET_NAME }} --delete
        aws s3 cp ./dist/index.html s3://${{ secrets.S3_BUCKET_NAME }}/index.html --cache-control "no-cache"

    - name: Invalidate CloudFront cache
      run: |
        aws cloudfront create-invalidation \
          --distribution-id ${{ secrets.CLOUDFRONT_DISTRIBUTION_ID }} \
          --paths "/*"

    - name: Deployment notification
      run: |
        echo "✅ Website deployed successfully!"
        echo "🌐 URL: https://${{ secrets.DOMAIN_NAME }}"
```

### Required GitHub Secrets

Configure these secrets in your GitHub repository settings:

| Secret Name | Description | Example |
|-------------|-------------|---------|
| `AWS_ACCESS_KEY_ID` | Access key from module output | `AKIA...` |
| `AWS_SECRET_ACCESS_KEY` | Secret key from module output | `wJalr...` |
| `S3_BUCKET_NAME` | S3 bucket name from module output | `example.com` |
| `CLOUDFRONT_DISTRIBUTION_ID` | CloudFront distribution ID from module output | `E1234567890ABC` |
| `DOMAIN_NAME` | Your domain name | `example.com` |

### Getting Module Outputs

After applying the Terraform module, get the required values:

```bash
# Get S3 bucket name
terraform output bucket_name

# Get CloudFront distribution ID
terraform output cloudfront_distribution_id

# Get CI/CD credentials
terraform output cicd_access_key_id
terraform output cicd_secret_access_key
```

## License

MIT License - see LICENSE file for details.
