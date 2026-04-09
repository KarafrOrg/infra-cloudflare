resource "cloudflare_zero_trust_tunnel_cloudflared" "tunnels" {
  for_each = var.tunnels

  account_id = var.account_id
  name       = "${each.key}-${var.name_suffix}"
  config_src = "cloudflare"
}

data "cloudflare_zero_trust_tunnel_cloudflared_token" "tunnel_tokens" {
  for_each = var.tunnels

  account_id = var.account_id
  tunnel_id  = cloudflare_zero_trust_tunnel_cloudflared.tunnels[each.key].id
}

resource "cloudflare_dns_record" "tunnel_records" {
  for_each = var.tunnels

  zone_id = var.zone_id
  name    = each.value.hostname
  content = "${cloudflare_zero_trust_tunnel_cloudflared.tunnels[each.key].id}.cfargotunnel.com"
  type    = "CNAME"
  ttl     = 1
  proxied = true
}

resource "cloudflare_zero_trust_tunnel_cloudflared_config" "tunnel_configs" {
  for_each = var.tunnels

  tunnel_id  = cloudflare_zero_trust_tunnel_cloudflared.tunnels[each.key].id
  account_id = var.account_id

  config = {
    ingress = [
      {
        hostname = each.value.hostname
        service  = each.value.service
      },
      {
        service = "http_status:404"
      }
    ]
  }
}
