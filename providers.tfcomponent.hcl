# Shared provider configurations for Cloudflare Stacks
# This file defines reusable provider configurations

required_providers {
  cloudflare = {
    source  = "cloudflare/cloudflare"
    version = "~> 5.0"
  }
}

# Main Cloudflare provider
provider "cloudflare" "main" {
  config {
    email     = var.cloudflare_email
    api_token = var.cloudflare_api_token
  }
}
