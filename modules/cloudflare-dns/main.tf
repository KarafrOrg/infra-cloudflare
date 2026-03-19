terraform {
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 5.0"
    }
  }
}

resource "cloudflare_zone" "main" {
  account = {
    id = var.account_id
  }
  name = var.domain
}

resource "cloudflare_zone_dns_settings" "main" {
  zone_id        = cloudflare_zone.main.id
  foundation_dns = false
  ns_ttl         = 86400
  soa = {
    expire  = 604800
    min_ttl = 1800
    refresh = 10000
    retry   = 2400
    rname   = "dns.cloudflare.com"
    ttl     = 3600
  }
  zone_mode = "standard"
  nameservers = {
    type = "cloudflare.standard"
  }
  secondary_overrides = false
  multi_provider      = false
  flatten_all_cnames  = false
  internal_dns        = {}
}

resource "cloudflare_dns_record" "records" {
  for_each = var.dns_records

  zone_id = cloudflare_zone.main.id
  name    = each.value.name
  type    = each.value.type
  content = each.value.content
  ttl     = try(each.value.ttl, 1)
  proxied = try(each.value.proxied, true)
}
