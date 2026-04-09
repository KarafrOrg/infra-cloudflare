variable "zone_id" {
  type        = string
  description = "Cloudflare account ID"
}

variable "domain" {
  type        = string
  description = "The domain name to manage in Cloudflare"
}

variable "dns_records" {
  type = map(object({
    name    = string
    type    = string
    content = string
    ttl     = optional(number)
    proxied = optional(bool)
  }))
  description = "Map of DNS records to create"
  default     = {}
}
