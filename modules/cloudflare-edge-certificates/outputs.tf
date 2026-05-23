output "edge_certificate_pack_ids" {
  description = "Map of edge certificate pack IDs keyed by certificate name."
  value       = { for key, cert in cloudflare_certificate_pack.edge_certificates : key => cert.id }
}

output "edge_certificate_pack_statuses" {
  description = "Map of edge certificate statuses keyed by certificate name."
  value       = { for key, cert in cloudflare_certificate_pack.edge_certificates : key => cert.status }
}

output "edge_certificate_pack_hosts" {
  description = "Map of configured host lists keyed by certificate name."
  value       = { for key, cert in cloudflare_certificate_pack.edge_certificates : key => cert.hosts }
}
