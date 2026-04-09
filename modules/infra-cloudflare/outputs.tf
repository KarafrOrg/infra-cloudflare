output "zone_id" {
  description = "The Cloudflare zone ID."
  value       = module.cloudflare_dns.zone_id
}

output "zone_name" {
  description = "The domain name managed in Cloudflare."
  value       = module.cloudflare_dns.zone_name
}

output "nameservers" {
  description = "Cloudflare name servers for the zone."
  value       = module.cloudflare_dns.nameservers
}

output "zone_status" {
  description = "Status of the Cloudflare zone."
  value       = module.cloudflare_dns.status
}

output "dns_record_ids" {
  description = "Map of DNS record IDs keyed by record name."
  value       = module.cloudflare_dns.dns_record_ids
}

output "waf_custom_ruleset_id" {
  description = "ID of the custom WAF ruleset."
  value       = module.cloudflare_waf.ruleset_id
}

output "waf_rate_limit_ruleset_id" {
  description = "ID of the rate limiting ruleset."
  value       = module.cloudflare_waf.rate_limit_ruleset_id
}

output "waf_firewall_ruleset_id" {
  description = "ID of the firewall ruleset."
  value       = module.cloudflare_waf.firewall_ruleset_id
}

output "tunnel_ids" {
  description = "Map of tunnel IDs keyed by tunnel name."
  value       = module.cloudflare_tunnel.tunnel_ids
}

output "tunnel_tokens" {
  description = "Map of tunnel tokens keyed by tunnel name."
  value       = module.cloudflare_tunnel.tunnel_tokens
  sensitive   = true
}

output "tunnel_cnames" {
  description = "Map of tunnel CNAME record contents keyed by tunnel name."
  value       = module.cloudflare_tunnel.tunnel_cnames
}

output "access_group_ids" {
  description = "Map of Access group IDs keyed by group name."
  value       = module.cloudflare_access.access_group_ids
}

output "access_application_ids" {
  description = "Map of Access application IDs keyed by application name."
  value       = module.cloudflare_access.access_application_ids
}

output "access_policy_ids" {
  description = "Map of Access policy IDs keyed by policy name."
  value       = module.cloudflare_access.access_policy_ids
}
