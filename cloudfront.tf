resource "aws_cloudfront_distribution" "this" {
  enabled             = true
  is_ipv6_enabled     = true
  default_root_object = "index.html"
  price_class         = "PriceClass_100"
  aliases = var.use_external_dns ? [] : [var.domain_name]

  tags = merge(var.tags, {
    Name        = "CloudFront Distribution for ${var.domain_name}"
    Purpose     = "CDN for static website"
    Environment = "Production"
  })

  origin {
    domain_name = aws_s3_bucket_website_configuration.this.website_endpoint
    origin_id   = "s3-origin"
    
    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "http-only"
      origin_ssl_protocols   = ["TLSv1.2"]
    }
  }

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "s3-origin"
    viewer_protocol_policy = "redirect-to-https"
    compress = true

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    acm_certificate_arn      = var.use_external_dns ? null : aws_acm_certificate.this.arn
    cloudfront_default_certificate = var.use_external_dns ? true : false
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2021"
  }
}
