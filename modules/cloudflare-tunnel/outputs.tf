# output "tunnel_ids" {
#   description = "Map of tunnel IDs"
#   value       = { for k, v in cloudflare_tunnel.tunnels : k => v.id }
# }

# output "tunnel_tokens" {
#   description = "Map of tunnel tokens"
#   value       = { for k, v in cloudflare_tunnel.tunnels : k => v.tunnel_token }
#   sensitive   = true
# }

