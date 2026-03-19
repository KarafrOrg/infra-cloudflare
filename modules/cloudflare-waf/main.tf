terraform {
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 5.0"
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

  rules = [
    for rule in var.custom_rules : {
      action      = rule.action
      expression  = rule.expression
      description = rule.description
      enabled     = try(rule.enabled, true)
    }
  ]
}

# Rate Limiting Rules using Ruleset
resource "cloudflare_ruleset" "rate_limits" {
  count = length(var.rate_limits) > 0 ? 1 : 0

  zone_id     = var.zone_id
  name        = "Rate Limiting - ${var.name_suffix}"
  description = "Rate limiting rules for zone"
  kind        = "zone"
  phase       = "http_ratelimit"

  rules = [
    for key, rule in var.rate_limits : {
      action      = "block"
      expression  = rule.expression
      description = rule.description
      enabled     = !try(rule.disabled, false)
      ratelimit = {
        characteristics = try(rule.characteristics, ["ip.src"])
        period          = rule.period
      }
    }
  ]
}

# Firewall Rules using Ruleset
resource "cloudflare_ruleset" "firewall_rules" {
  count = length(var.firewall_rules) > 0 ? 1 : 0

  zone_id     = var.zone_id
  name        = "Firewall Rules - ${var.name_suffix}"
  description = "Firewall rules for zone"
  kind        = "zone"
  phase       = "http_request_firewall_custom"

  rules = [
    for key, rule in var.firewall_rules : {
      action      = rule.action
      expression  = rule.expression
      description = rule.description
      enabled     = !try(rule.paused, false)
    }
  ]
}
