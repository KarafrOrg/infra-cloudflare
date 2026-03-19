# region Common
variable "cloudflare_api_token" {
  type        = string
  description = "Cloudflare API token"
  sensitive   = true
  ephemeral   = true
}

variable "cloudflare_account_id" {
  type        = string
  description = "Cloudflare account ID"
}

variable "environment" {
  type        = string
  description = "Environment name"
  default     = "prod"
}

variable "domain" {
  type        = string
  description = "The domain name to manage in Cloudflare"
}

variable "cloudflare_plan" {
  type        = string
  description = "Cloudflare plan type (free, pro, business, enterprise)"
  default     = "free"
}
# endregion

# region SSL/TLS Settings
variable "ssl_mode" {
  type        = string
  description = "SSL/TLS encryption mode (off, flexible, full, strict)"
  default     = "full_strict"
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
  description = "Minimum TLS version (1.0, 1.1, 1.2, 1.3)"
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
  default     = true
}

variable "hsts_max_age" {
  type        = number
  description = "HSTS max age in seconds"
  default     = 31536000
}

variable "hsts_include_subdomains" {
  type        = bool
  description = "Whether to include subdomains in HSTS"
  default     = true
}

variable "hsts_preload" {
  type        = bool
  description = "Whether to enable HSTS preload"
  default     = true
}

# endregion

# region DNS
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
# endregion

# region WAF
variable "waf_custom_rules" {
  type = list(object({
    action      = string
    expression  = string
    description = string
    enabled     = optional(bool)
  }))
  description = "List of custom WAF rules"
  default     = []
}

variable "waf_rate_limits" {
  type = map(object({
    threshold   = number
    period      = number
    url_pattern = string
    action_mode = string
    timeout     = optional(number)
    description = string
    disabled    = optional(bool)
  }))
  description = "Map of rate limiting rules"
  default     = {}
}

variable "waf_firewall_rules" {
  type = map(object({
    expression  = string
    description = string
    action      = string
    priority    = optional(number)
    paused      = optional(bool)
  }))
  description = "Map of firewall rules"
  default     = {}
}
# endregion
