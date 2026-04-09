variable "cloudflare_api_token" {
  description = "Cloudflare API token with permissions to manage DNS, WAF, Tunnels and Access."
  type        = string
  sensitive   = true
  ephemeral   = true
}

variable "cloudflare_account_id" {
  description = "Cloudflare account ID."
  type        = string
  sensitive   = true
}

variable "environment" {
  description = "Environment name (e.g., prod, staging, dev)."
  type        = string
}

variable "domain" {
  description = "The root domain name to manage in Cloudflare."
  type        = string
}

variable "dns_records" {
  description = "Map of DNS records to create."
  type = map(object({
    name    = string
    type    = string
    content = string
    ttl     = optional(number)
    proxied = optional(bool)
  }))
  default = {}
}

variable "waf_custom_rules" {
  description = "List of custom WAF rules."
  type = list(object({
    action      = string
    expression  = string
    description = string
    enabled     = optional(bool)
  }))
  default = []
}

variable "waf_rate_limits" {
  description = "Map of rate limiting rules."
  type = map(object({
    threshold       = number
    period          = number
    expression      = string
    timeout         = optional(number)
    description     = string
    disabled        = optional(bool)
    characteristics = optional(list(string))
  }))
  default = {}
}

variable "waf_firewall_rules" {
  description = "Map of firewall rules."
  type = map(object({
    expression  = string
    description = string
    action      = string
    priority    = optional(number)
    paused      = optional(bool)
  }))
  default = {}
}

variable "tunnels" {
  description = "Map of tunnel configurations."
  type = map(object({
    service  = string
    hostname = string
    secret   = string
  }))
  default = {}
}

variable "access_groups" {
  description = "Map of access group configurations."
  type = map(object({
    emails = list(string)
  }))
  default = {}
}

variable "access_applications" {
  description = "Map of access application configurations."
  type = map(object({
    domain           = string
    session_duration = optional(string)
  }))
  default = {}
}

variable "access_policies" {
  description = "Map of access policy configurations."
  type = map(object({
    app_key    = string
    group_key  = string
    precedence = number
    decision   = string
  }))
  default = {}
}
