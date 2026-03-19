# Authentication variables
variable "cloudflare_api_key" {
  description = "Cloudflare API token with permissions to manage DNS records."
  type        = string
  sensitive   = true
  ephemeral   = true
}

variable "cloudflare_email" {
  description = "Email address associated with the Cloudflare account."
  type        = string
  sensitive   = true
  ephemeral   = true
}

variable "cloudflare_account_id" {
  description = "Cloudflare account ID"
  type        = string
  sensitive   = true
  ephemeral   = true
}

# General variables
variable "environment" {
  description = "Environment name (e.g., dev, staging, prod)"
  type        = string
}

variable "domain" {
  description = "The domain name to manage in Cloudflare"
  type        = string
}

# DNS variables
variable "dns_plan" {
  description = "Cloudflare plan type"
  type        = string
  default     = "free"
}

variable "ssl_mode" {
  description = "SSL/TLS encryption mode"
  type        = string
  default     = "flexible"
}

variable "always_use_https" {
  description = "Whether to always use HTTPS"
  type        = string
  default     = "on"
}

variable "automatic_https_rewrites" {
  description = "Whether to enable automatic HTTPS rewrites"
  type        = string
  default     = "on"
}

variable "min_tls_version" {
  description = "Minimum TLS version"
  type        = string
  default     = "1.2"
}

variable "tls_1_3" {
  description = "Whether to enable TLS 1.3"
  type        = string
  default     = "on"
}

variable "enable_hsts" {
  description = "Whether to enable HSTS"
  type        = bool
  default     = false
}

# WAF variables
variable "waf_custom_rules" {
  description = "List of custom WAF rules"
  type = list(object({
    action      = string
    expression  = string
    description = string
    enabled = optional(bool)
  }))
  default = []
}

variable "waf_rate_limits" {
  description = "Map of rate limiting rules"
  type = map(object({
    threshold   = number
    period      = number
    expression  = string
    timeout = optional(number)
    description = string
    disabled = optional(bool)
    characteristics = optional(list(string))
  }))
  default = {}
}

variable "waf_firewall_rules" {
  description = "Map of firewall rules"
  type = map(object({
    expression  = string
    description = string
    action      = string
    priority = optional(number)
    paused = optional(bool)
  }))
  default = {}
}

# Tunnel variables
variable "tunnels" {
  description = "Map of tunnel configurations"
  type = map(object({
    service  = string
    hostname = string
    secret   = string
  }))
  default = {}
}

# Access variables
variable "access_groups" {
  description = "Map of access group configurations"
  type = map(object({
    emails = list(string)
  }))
  default = {}
}

variable "access_applications" {
  description = "Map of access application configurations"
  type = map(object({
    domain = string
    session_duration = optional(string)
  }))
  default = {}
}

variable "access_policies" {
  description = "Map of access policy configurations"
  type = map(object({
    app_key    = string
    group_key  = string
    precedence = number
    decision   = string
  }))
  default = {}
}

