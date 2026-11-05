variable "account_id" {
  type        = string
  description = "Cloudflare account ID"
}

variable "name_suffix" {
  type        = string
  description = "Suffix for resource names (usually environment)"
}

variable "github_client_id" {
  type        = string
  description = "GitHub OAuth app client ID for Cloudflare Access identity provider."
}

variable "github_client_secret" {
  type        = string
  description = "GitHub OAuth app client secret for Cloudflare Access identity provider."
  sensitive   = true
}

variable "access_groups" {
  type = map(object({
    emails   = optional(list(string), [])
    warp     = optional(bool, false)
    everyone = optional(bool, false)
    github_teams = optional(list(object({
      org  = string
      team = optional(string)
    })), [])
  }))
  description = "Map of access group configurations"
  default     = {}
}

variable "access_applications" {
  type = map(object({
    domain           = string
    session_duration = optional(string)
  }))
  description = "Map of access application configurations"
  default     = {}
}

variable "access_policies" {
  type = map(object({
    app_key          = string
    group_key        = optional(string)
    include_everyone = optional(bool, false)
    precedence       = number
    decision         = string
  }))
  description = "Map of access policy configurations"
  default     = {}
}

variable "warp_split_tunnel_exclude" {
  type        = list(string)
  description = "CIDRs excluded from the WARP default profile tunnel. When null the default profile is not managed. Anything not listed here is sent through WARP."
  default     = null
}

variable "gateway_dns_overrides" {
  type = map(object({
    domains = list(string)
    ips     = list(string)
  }))
  description = "Gateway DNS policies answering the given domains (and subdomains) with private IPs for WARP clients only."
  default     = {}
}
