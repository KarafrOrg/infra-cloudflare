output "zone_id" {
  description = "The Cloudflare zone ID"
  value       = cloudflare_zone.main.id
}

output "zone_name" {
  description = "The domain name"
  value       = cloudflare_zone.main.name
}

output "nameservers" {
  description = "Cloudflare name servers for the zone"
  value       = cloudflare_zone.main.name_servers
}

output "status" {
  description = "Status of the zone"
  value       = cloudflare_zone.main.status
}

output "dns_record_ids" {
  description = "Map of DNS record IDs"
  value       = { for k, v in cloudflare_dns_record.records : k => v.id }
}
