module "static_website" {
  source = "../../"

  domain_name      = "myapp.example.com"
  hosted_zone_id   = "Z1234567890ABC"
  
  tags = {
    Environment = "production"
    Project     = "my-website"
    Owner       = "devops-team"
  }
}

output "website_url" {
  value = "https://${module.static_website.cloudfront_domain_name}"
}

output "cicd_credentials" {
  value = {
    access_key_id     = module.static_website.cicd_access_key_id
    secret_access_key = module.static_website.cicd_secret_access_key
  }
  sensitive = true
}
