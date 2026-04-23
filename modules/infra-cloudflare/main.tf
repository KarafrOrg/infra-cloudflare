module "cloudflare_dns" {
  source = "../../modules/cloudflare-dns"

  account_id  = var.cloudflare_account_id
  domain      = var.domain
  dns_records = var.dns_records
}

module "cloudflare_waf" {
  source = "../../modules/cloudflare-waf"

  zone_id        = module.cloudflare_dns.zone_id
  name_suffix    = var.environment
  custom_rules   = var.waf_custom_rules
  rate_limits    = var.waf_rate_limits
  firewall_rules = var.waf_firewall_rules
}

module "cloudflare_tunnel" {
  source = "../../modules/cloudflare-tunnel"

  account_id  = var.cloudflare_account_id
  zone_id     = module.cloudflare_dns.zone_id
  name_suffix = var.environment
  tunnels     = var.tunnels
}

module "cloudflare_access" {
  source = "../../modules/cloudflare-access"

  account_id           = var.cloudflare_account_id
  name_suffix          = var.environment
  github_client_id     = var.github_client_id
  github_client_secret = var.github_client_secret
  access_groups        = var.access_groups
  access_applications  = var.access_applications
  access_policies      = var.access_policies
}
