output "tunnel_ids" {
  description = "Map of tunnel IDs"
  value       = { for k, v in cloudflare_zero_trust_tunnel_cloudflared.tunnels : k => v.id }
}

output "tunnel_tokens" {
  description = "Map of tunnel tokens (use data source to retrieve)"
  value       = { for k, v in data.cloudflare_zero_trust_tunnel_cloudflared_token.tunnel_tokens : k => v.token }
  sensitive   = true
}

output "tunnel_cnames" {
  description = "Map of tunnel CNAME records"
  value       = { for k, v in cloudflare_dns_record.tunnel_records : k => v.content }
}

output "gcp_tunnel_token_secret_ids" {
  description = "Map of GCP Secret Manager secret IDs keyed by tunnel name"
  value       = { for k, v in google_secret_manager_secret.tunnel_tokens : k => v.id }
}

