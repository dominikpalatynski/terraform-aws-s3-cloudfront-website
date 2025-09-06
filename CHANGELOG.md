# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [1.0.0] - 2024-01-XX

### Added
- Initial release
- S3 bucket for static website hosting
- CloudFront CDN distribution
- SSL certificate with DNS validation
- Route 53 DNS records (A and AAAA)
- IAM user and policy for CI/CD deployments
- IPv6 support
- HTTPS redirect
- Custom error page configuration

### Security
- Proper IAM permissions for CI/CD user
- SSL certificate validation
- Public access controls for S3 bucket
