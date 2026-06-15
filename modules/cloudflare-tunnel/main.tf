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
  for_each = {
    for tunnel_key, tunnel in var.tunnels : tunnel_key => tunnel
    if try(tunnel.create_dns_record, true)
  }

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
        origin_request = each.value.no_tls_verify ? {
          no_tls_verify = true
        } : null
      },
      {
        service = "http_status:404"
      }
    ]
  }
}

resource "cloudflare_zero_trust_tunnel_cloudflared_route" "cidr_routes" {
  for_each = {
    for entry in flatten([
      for tunnel_key, tunnel in var.tunnels : [
        for cidr in tunnel.cidr_routes : {
          key        = "${tunnel_key}__${replace(cidr, "/", "_")}"
          tunnel_key = tunnel_key
          cidr       = cidr
        }
      ]
    ]) : entry.key => entry
  }

  account_id = var.account_id
  tunnel_id  = cloudflare_zero_trust_tunnel_cloudflared.tunnels[each.value.tunnel_key].id
  network    = each.value.cidr
}

resource "google_secret_manager_secret" "tunnel_tokens" {
  for_each = local.tunnels_for_gcp_secret_manager

  secret_id = "${var.gcp_tunnel_token_secret_prefix}${replace(each.key, "/[^a-zA-Z0-9_-]/", "-")}"
  labels    = var.gcp_secret_labels

  replication {
    auto {}
  }
}

resource "google_secret_manager_secret_version" "tunnel_tokens" {
  for_each = local.tunnels_for_gcp_secret_manager

  secret      = google_secret_manager_secret.tunnel_tokens[each.key].id
  secret_data = data.cloudflare_zero_trust_tunnel_cloudflared_token.tunnel_tokens[each.key].token
}
