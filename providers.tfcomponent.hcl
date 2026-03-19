# Shared provider configurations for Cloudflare Stacks
# This file defines reusable provider configurations

required_providers {
  cloudflare = {
    source  = "cloudflare/cloudflare"
    version = "~> 4.0"
  }
}

# Main Cloudflare provider
provider "cloudflare" "main" {
  config {
    api_token = var.cloudflare_api_token
  }
}

# Required variable for API token
variable "cloudflare_api_token" {
  type        = string
  description = "Cloudflare API token for authentication"
  sensitive   = true
  ephemeral   = true
}
