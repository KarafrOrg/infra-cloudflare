output "zone_id" {
  description = "ID of the Cloudflare zone."
  value       = module.infra-cloudflare.zone_id
}

output "zone_name" {
  description = "Name of the Cloudflare zone."
  value       = module.infra-cloudflare.zone_name
}

output "zone_status" {
  description = "Status of the Cloudflare zone."
  value       = module.infra-cloudflare.zone_status
}

output "nameservers" {
  description = "Cloudflare name servers for the zone."
  value       = module.infra-cloudflare.nameservers
}

output "dns_record_ids" {
  description = "Map of DNS record IDs keyed by record name."
  value       = module.infra-cloudflare.dns_record_ids
}

output "waf_custom_ruleset_id" {
  description = "ID of the custom WAF ruleset."
  value       = module.infra-cloudflare.waf_custom_ruleset_id
}

output "waf_rate_limit_ruleset_id" {
  description = "ID of the rate limiting ruleset."
  value       = module.infra-cloudflare.waf_rate_limit_ruleset_id
}

output "waf_firewall_ruleset_id" {
  description = "ID of the firewall ruleset."
  value       = module.infra-cloudflare.waf_firewall_ruleset_id
}

output "tunnel_ids" {
  description = "Map of tunnel IDs keyed by tunnel name."
  value       = module.infra-cloudflare.tunnel_ids
}

output "tunnel_tokens" {
  description = "Map of tunnel tokens keyed by tunnel name."
  value       = module.infra-cloudflare.tunnel_tokens
  sensitive   = true
}

output "tunnel_cnames" {
  description = "Map of tunnel CNAME record contents keyed by tunnel name."
  value       = module.infra-cloudflare.tunnel_cnames
}

output "access_group_ids" {
  description = "Map of Access group IDs keyed by group name."
  value       = module.infra-cloudflare.access_group_ids
}

output "access_application_ids" {
  description = "Map of Access application IDs keyed by application name."
  value       = module.infra-cloudflare.access_application_ids
}

output "access_policy_ids" {
  description = "Map of Access policy IDs keyed by policy name."
  value       = module.infra-cloudflare.access_policy_ids
}
