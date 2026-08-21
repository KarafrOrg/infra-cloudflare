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
  description = "Cloudflare Tunnel definitions."

  type = map(object({
    hostname          = string
    secret            = string
    service           = optional(string)
    create_dns_record = optional(bool, true)
    cidr_routes       = optional(list(string), [])
    no_tls_verify     = optional(bool, false)

    ingress = optional(list(object({
      hostname = optional(string)
      path     = optional(string)
      service  = optional(string)

      origin_request = optional(object({
        no_tls_verify = optional(bool)
      }))
    })), null)
  }))
}

variable "gcp_push_tunnel_tokens" {
  description = "When true, writes Cloudflare tunnel tokens to GCP Secret Manager."
  type        = bool
  default     = false
}

variable "gcp_project_id" {
  description = "GCP project ID used for Secret Manager resources when gcp_push_tunnel_tokens is enabled."
  type        = string
  default     = null
  nullable    = true
}

variable "gcp_tunnel_token_secret_prefix" {
  description = "Prefix for generated GCP Secret Manager secret IDs for Cloudflare tunnel tokens."
  type        = string
  default     = "cloudflare-tunnel-token-"
}

variable "gcp_secret_labels" {
  description = "Labels to apply on generated GCP Secret Manager secrets."
  type        = map(string)
  default     = {}
}

