variable "cloudflare_api_key" {
  description = "Cloudflare API token with permissions to manage DNS records."
  type        = string
  sensitive   = true
}

variable "cloudflare_email" {
  description = "Email address associated with the Cloudflare account."
  type        = string
  sensitive   = true
}
