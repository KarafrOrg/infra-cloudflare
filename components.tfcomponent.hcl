component "cloudflare_dns" {
  source = "./modules/cloudflare-dns"

  providers = {
    cloudflare = provider.cloudflare.main
  }

  inputs = {
    account_id                = var.cloudflare_account_id
    domain                    = var.domain
    plan                      = var.dns_plan
    ssl_mode                  = var.ssl_mode
    always_use_https          = var.always_use_https
    automatic_https_rewrites  = var.automatic_https_rewrites
    min_tls_version           = var.min_tls_version
    tls_1_3                   = var.tls_1_3
    enable_hsts               = var.enable_hsts
  }
}

component "cloudflare_waf" {
  source = "./modules/cloudflare-waf"

  providers = {
    cloudflare = provider.cloudflare.main
  }

  inputs = {
    zone_id        = component.cloudflare_dns.zone_id
    name_suffix    = var.environment
    custom_rules   = var.waf_custom_rules
    rate_limits    = var.waf_rate_limits
    firewall_rules = var.waf_firewall_rules
  }
}

component "cloudflare_tunnel" {
  source = "./modules/cloudflare-tunnel"

  providers = {
    cloudflare = provider.cloudflare.main
  }

  inputs = {
    account_id  = var.cloudflare_account_id
    zone_id     = component.cloudflare_dns.zone_id
    name_suffix = var.environment
    tunnels     = var.tunnels
  }
}

component "cloudflare_access" {
  source = "./modules/cloudflare-access"

  providers = {
    cloudflare = provider.cloudflare.main
  }

  inputs = {
    account_id           = var.cloudflare_account_id
    zone_id              = component.cloudflare_dns.zone_id
    name_suffix          = var.environment
    access_groups        = var.access_groups
    access_applications  = var.access_applications
    access_policies      = var.access_policies
  }
}
