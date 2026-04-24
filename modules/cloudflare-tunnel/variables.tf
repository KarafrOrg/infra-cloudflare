variable "account_id" {
  description = "Cloudflare account ID"
  type        = string
  sensitive   = true
}

variable "name_suffix" {
  description = "Suffix for resource names (usually environment)"
  type        = string
}
variable "zone_id" {
  description = "Cloudflare zone ID"
  type        = string
}

variable "tunnels" {
  default     = {}
  description = "Map of tunnel configurations"
  type = map(object({
    service     = string
    hostname    = string
    secret      = string
    cidr_routes = optional(list(string), [])
  }))
}
