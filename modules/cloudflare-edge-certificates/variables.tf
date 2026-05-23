variable "zone_id" {
  description = "Cloudflare zone ID used for edge certificate packs."
  type        = string
}

variable "edge_certificates" {
  description = "Map of edge certificate pack definitions keyed by a logical name."
  type = map(object({
    enabled               = optional(bool, true)
    hosts                 = list(string)
    type                  = optional(string)
    validation_method     = optional(string)
    validity_days         = optional(number)
    certificate_authority = optional(string)
    cloudflare_branding   = optional(bool)
  }))
  default = {}
}
