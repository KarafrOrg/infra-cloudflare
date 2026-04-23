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
    emails = optional(list(string), [])
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
    app_key    = string
    group_key  = string
    precedence = number
    decision   = string
  }))
  description = "Map of access policy configurations"
  default     = {}
}
