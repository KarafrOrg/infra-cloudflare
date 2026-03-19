component "cloudflare_dns" {
  source = "./modules/cloudflare-dns"

  variables {
    variable "cloudflare_account_id" {
      type = string
    }

    variable "domain" {
      type = string
    }

    variable "environment" {
      type = string
    }

    variable "dns_records" {
      type = list(object({
        name    = string
        type    = string
        value   = string
        proxied = bool
        ttl = optional(number, 1)
        priority = optional(number)
      }))
      default = []
    }

    variable "enable_dnssec" {
      type    = bool
      default = true
    }
  }

  outputs {
    output "zone_id" {
      type = string
    }

    output "zone_name" {
      type = string
    }

    output "name_servers" {
      type = list(string)
    }
  }
}

component "cloudflare_waf" {
  source = "./modules/cloudflare-waf"

  variables {
    variable "zone_id" {
      type = string
    }

    variable "environment" {
      type = string
    }

    variable "waf_rules" {
      type = list(object({
        description = string
        expression  = string
        action      = string
        priority = optional(number)
        enabled = optional(bool, true)
      }))
      default = []
    }

    variable "rate_limiting_rules" {
      type = list(object({
        description      = string
        match_expression = string
        threshold        = number
        period           = number
        action           = string
      }))
      default = []
    }

    variable "enable_bot_management" {
      type    = bool
      default = true
    }
  }

  outputs {
    output "ruleset_id" {
      type = string
    }

    output "waf_rule_ids" {
      type = list(string)
    }
  }
}

component "cloudflare_tunnel" {
  source = "./modules/cloudflare-tunnel"

  variables {
    variable "cloudflare_account_id" {
      type = string
    }

    variable "tunnel_name" {
      type = string
    }

    variable "tunnel_secret" {
      type      = string
      sensitive = true
    }

    variable "tunnel_routes" {
      type = list(object({
        hostname = string
        service  = string
      }))
      default = []
    }
  }

  outputs {
    output "tunnel_id" {
      type = string
    }

    output "tunnel_token" {
      type      = string
      sensitive = true
    }
  }
}

component "cloudflare_access" {
  source = "./modules/cloudflare-access"

  variables {
    variable "cloudflare_account_id" {
      type = string
    }

    variable "zone_id" {
      type = string
    }

    variable "application_name" {
      type = string
    }

    variable "domain" {
      type = string
    }

    variable "allowed_emails" {
      type = list(string)
      default = []
    }

    variable "session_duration" {
      type    = string
      default = "24h"
    }
  }

  outputs {
    output "application_id" {
      type = string
    }

    output "application_domain" {
      type = string
    }
  }
}
