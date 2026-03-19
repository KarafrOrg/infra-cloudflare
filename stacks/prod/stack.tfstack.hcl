required_providers {
  cloudflare = {
    source  = "cloudflare/cloudflare"
    version = "~> 5.0"
  }
}

provider "cloudflare" "main" {
  config {
    api_token = var.cloudflare_api_token
  }
}

component "dns" {
  source = "../../modules/cloudflare-dns"

  providers = {
    cloudflare = provider.cloudflare.main
  }

  inputs = {
    account_id               = var.cloudflare_account_id
    domain                   = var.domain
    plan                     = var.cloudflare_plan
    ssl_mode                 = var.ssl_mode
    always_use_https         = var.always_use_https
    automatic_https_rewrites = var.automatic_https_rewrites
    min_tls_version          = var.min_tls_version
    tls_1_3                  = var.tls_1_3
    enable_hsts              = var.enable_hsts
    hsts_max_age             = var.hsts_max_age
    hsts_include_subdomains  = var.hsts_include_subdomains
    hsts_preload             = var.hsts_preload
    dns_records              = var.dns_records
  }
}

component "waf" {
  source = "../../modules/cloudflare-waf"

  providers = {
    cloudflare = provider.cloudflare.main
  }

  inputs = {
    zone_id          = component.dns.zone_id
    name_suffix      = var.environment
    custom_rules     = var.waf_custom_rules
    rate_limits      = var.waf_rate_limits
    firewall_rules   = var.waf_firewall_rules
  }
}

# TODO: Add Tunnels Component
# component "tunnels" {
#   source = "../../modules/cloudflare-tunnel"
#   providers = {
#     cloudflare = provider.cloudflare.main
#   }
#   inputs = {
#     zone_id     = component.dns.zone_id
#     name_suffix = var.environment
#     tunnels     = var.tunnels
#   }
# }

# TODO: Add Access Component
# component "access" {
#   source = "../../modules/cloudflare-access"
#   providers = {
#     cloudflare = provider.cloudflare.main
#   }
#   inputs = {
#     zone_id        = component.dns.zone_id
#     account_id     = var.cloudflare_account_id
#     name_suffix    = var.environment
#     access_groups  = var.access_groups
#     access_policies = var.access_policies
#   }
# }

