variable "account_id" {
  type        = string
  description = "Cloudflare account ID"
  ephemeral   = true
}

variable "zone_id" {
  type        = string
  description = "Cloudflare zone ID"
}

variable "name_suffix" {
  type        = string
  description = "Suffix for resource names (usually environment)"
}

variable "access_groups" {
  type = map(object({
    emails = list(string)
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
