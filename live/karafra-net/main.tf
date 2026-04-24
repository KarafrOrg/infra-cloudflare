module "infra-cloudflare" {
  source                = "../../modules/infra-cloudflare"
  cloudflare_api_token  = var.cloudflare_api_token
  cloudflare_account_id = var.cloudflare_account_id
  domain                = var.domain
  environment           = var.environment
  dns_records           = var.dns_records
  waf_custom_rules      = var.waf_custom_rules
  waf_rate_limits       = var.waf_rate_limits
  waf_firewall_rules    = var.waf_firewall_rules
  tunnels               = var.tunnels
  access_groups         = var.access_groups
  access_applications   = var.access_applications
  access_policies       = var.access_policies
  github_client_id      = var.github_client_id
  github_client_secret  = var.github_client_secret
}
