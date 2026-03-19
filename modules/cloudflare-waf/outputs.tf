output "ruleset_id" {
  description = "The ID of the WAF ruleset"
  value       = length(cloudflare_ruleset.waf_custom_rules) > 0 ? cloudflare_ruleset.waf_custom_rules[0].id : null
}

output "waf_ruleset_id" {
  description = "The ID of the WAF ruleset (alias)"
  value       = length(cloudflare_ruleset.waf_custom_rules) > 0 ? cloudflare_ruleset.waf_custom_rules[0].id : null
}

output "rate_limit_ruleset_id" {
  description = "The ID of the rate limiting ruleset"
  value       = length(cloudflare_ruleset.rate_limits) > 0 ? cloudflare_ruleset.rate_limits[0].id : null
}

output "firewall_ruleset_id" {
  description = "The ID of the firewall ruleset"
  value       = length(cloudflare_ruleset.firewall_rules) > 0 ? cloudflare_ruleset.firewall_rules[0].id : null
}
