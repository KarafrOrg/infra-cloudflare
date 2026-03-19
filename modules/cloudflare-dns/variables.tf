variable "account_id" {
  type        = string
  description = "Cloudflare account ID"
  sensitive   = true
}

variable "domain" {
  type        = string
  description = "The domain name to manage in Cloudflare"
}

variable "plan" {
  type        = string
  description = "Cloudflare plan type"
  default     = "free"
}

variable "ssl_mode" {
  type        = string
  description = "SSL/TLS encryption mode"
  default     = "flexible"
}

variable "always_use_https" {
  type        = string
  description = "Whether to always use HTTPS"
  default     = "on"
}

variable "automatic_https_rewrites" {
  type        = string
  description = "Whether to enable automatic HTTPS rewrites"
  default     = "on"
}

variable "min_tls_version" {
  type        = string
  description = "Minimum TLS version"
  default     = "1.2"
}

variable "tls_1_3" {
  type        = string
  description = "Whether to enable TLS 1.3"
  default     = "on"
}

variable "enable_hsts" {
  type        = bool
  description = "Whether to enable HSTS"
  default     = false
}

variable "hsts_max_age" {
  type        = number
  description = "HSTS max age in seconds"
  default     = 31536000
}

variable "hsts_include_subdomains" {
  type        = bool
  description = "Whether to include subdomains in HSTS"
  default     = false
}

variable "hsts_preload" {
  type        = bool
  description = "Whether to enable HSTS preload"
  default     = false
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
