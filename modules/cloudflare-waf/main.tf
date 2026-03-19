terraform {
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 4.0"
    }
  }
}

# Custom WAF Rules using Rulesets
resource "cloudflare_ruleset" "waf_custom_rules" {
  count = length(var.custom_rules) > 0 ? 1 : 0

  zone_id     = var.zone_id
  name        = "Custom WAF Rules - ${var.name_suffix}"
  description = "Custom WAF rules for zone"
  kind        = "zone"
  phase       = "http_request_firewall_custom"

  rules {
    dynamic "rule" {
      for_each = var.custom_rules
      content {
        action      = rule.value.action
        expression  = rule.value.expression
        description = rule.value.description
        enabled     = try(rule.value.enabled, true)
      }
    }
  }
}

# Rate Limiting Rules using Ruleset
resource "cloudflare_ruleset" "rate_limits" {
  count = length(var.rate_limits) > 0 ? 1 : 0

  zone_id     = var.zone_id
  name        = "Rate Limiting - ${var.name_suffix}"
  description = "Rate limiting rules for zone"
  kind        = "zone"
  phase       = "http_ratelimit"

  rules {
    dynamic "rule" {
      for_each = var.rate_limits
      content {
        action      = "block"
        expression  = rule.value.expression
        description = rule.value.description
        enabled     = !try(rule.value.disabled, false)
      }
    }
  }
}

# Firewall Rules using Ruleset
resource "cloudflare_ruleset" "firewall_rules" {
  count = length(var.firewall_rules) > 0 ? 1 : 0

  zone_id     = var.zone_id
  name        = "Firewall Rules - ${var.name_suffix}"
  description = "Firewall rules for zone"
  kind        = "zone"
  phase       = "http_request_firewall_custom"

  rules {
    dynamic "rule" {
      for_each = var.firewall_rules
      content {
        action      = rule.value.action
        expression  = rule.value.expression
        description = rule.value.description
        enabled     = !try(rule.value.paused, false)
      }
    }
  }
}
