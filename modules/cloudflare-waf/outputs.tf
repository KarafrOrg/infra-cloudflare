output "ruleset_id" {
  description = "The ID of the WAF ruleset"
  value       = length(cloudflare_ruleset.waf_custom_rules) > 0 ? cloudflare_ruleset.waf_custom_rules[0].id : null
}

output "waf_ruleset_id" {
  description = "The ID of the WAF ruleset (alias)"
  value       = length(cloudflare_ruleset.waf_custom_rules) > 0 ? cloudflare_ruleset.waf_custom_rules[0].id : null
}

output "rate_limit_ids" {
  description = "Map of rate limit IDs"
  value       = { for k, v in cloudflare_rate_limit.rate_limits : k => v.id }
}

output "firewall_rule_ids" {
  description = "Map of firewall rule IDs"
  value       = { for k, v in cloudflare_firewall_rule.firewall_rules : k => v.id }
}
