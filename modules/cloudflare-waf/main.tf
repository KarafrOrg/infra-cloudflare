terraform {
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 5.0"
    }
  }
}

resource "cloudflare_ruleset" "waf_custom_rules" {
  count = length(var.custom_rules) > 0 ? 1 : 0

  zone_id     = var.zone_id
  name        = "Custom WAF Rules - ${var.name_suffix}"
  description = "Custom WAF rules for zone"
  kind        = "zone"
  phase       = "http_request_firewall_custom"

  dynamic "rules" {
    for_each = var.custom_rules
    content {
      action      = rules.value.action
      expression  = rules.value.expression
      description = rules.value.description
      enabled     = try(rules.value.enabled, true)
    }
  }
}

resource "cloudflare_rate_limit" "rate_limits" {
  for_each = var.rate_limits

  zone_id   = var.zone_id
  threshold = each.value.threshold
  period    = each.value.period

  description = each.value.description
  disabled    = try(each.value.disabled, false)
  action      = ""
  match       = ""
}

resource "cloudflare_filter" "filters" {
  for_each = var.firewall_rules

  zone_id     = var.zone_id
  description = each.value.description
  expression  = each.value.expression
  body {
    action   = "block"
    timeout  = 60
    log      = true
    paused   = try(each.value.paused, false)
    priority = try(each.value.priority, null)
  }
}

resource "cloudflare_firewall_rule" "firewall_rules" {
  for_each = var.firewall_rules

  zone_id     = var.zone_id
  description = each.value.description
  filter      = cloudflare_filter.filters[each.key]
  action      = each.value.action
  priority    = try(each.value.priority, null)
  paused      = try(each.value.paused, false)
}
