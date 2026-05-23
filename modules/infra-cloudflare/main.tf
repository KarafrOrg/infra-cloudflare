module "cloudflare_dns" {
  source = "../../modules/cloudflare-dns"

  account_id  = var.cloudflare_account_id
  domain      = var.domain
  dns_records = var.dns_records
}

module "cloudflare_edge_certificates" {
  source = "../../modules/cloudflare-edge-certificates"

  zone_id           = module.cloudflare_dns.zone_id
  edge_certificates = var.edge_certificates
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

  account_id                     = var.cloudflare_account_id
  zone_id                        = module.cloudflare_dns.zone_id
  name_suffix                    = var.environment
  tunnels                        = var.tunnels
  gcp_push_tunnel_tokens         = var.gcp_push_tunnel_tokens
  gcp_project_id                 = var.gcp_project_id
  gcp_tunnel_token_secret_prefix = var.gcp_tunnel_token_secret_prefix
  gcp_secret_labels              = var.gcp_secret_labels
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
