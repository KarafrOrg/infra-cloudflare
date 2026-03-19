variable "zone_id" {
  type        = string
  description = "Cloudflare zone ID"
}

variable "name_suffix" {
  type        = string
  description = "Environment name suffix"
  default     = ""
}

variable "custom_rules" {
  type = list(object({
    action      = string
    expression  = string
    description = string
    enabled     = optional(bool)
  }))
  description = "List of custom WAF rules"
  default     = []
}

variable "rate_limits" {
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

variable "firewall_rules" {
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
