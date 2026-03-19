output "zone_id" {
  type        = string
  description = "Cloudflare zone ID"
  value       = component.dns.zone_id
}

output "zone_name" {
  type        = string
  description = "Cloudflare zone name"
  value       = component.dns.zone_name
}

output "nameservers" {
  type        = list(string)
  description = "Cloudflare nameservers for the zone"
  value       = component.dns.nameservers
}

output "dns_record_ids" {
  type        = map(string)
  description = "Map of DNS record names to their IDs"
  value       = component.dns.dns_record_ids
}

output "waf_ruleset_id" {
  type        = string
  description = "WAF ruleset ID"
  value       = component.waf.waf_ruleset_id
}
