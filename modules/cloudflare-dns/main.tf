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
  name = "main"
}

resource "cloudflare_zone_dns_settings" "main" {
  zone_id = cloudflare_zone.main.id
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
