terraform {
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "5.15.0"
    }
    namecheap = {
      source  = "namecheap/namecheap"
      version = "2.2.0"
    }
  }
}
