# region Cloudflare account settings
cloudflare_account_id = "your-cloudflare-account-id"
domain                = "example.com"
cloudflare_plan       = "free"
environment           = "prod"
# endregion

# region SSL/TLS settings (Production: Use strict mode)
ssl_mode                 = "full_strict"
always_use_https         = "on"
automatic_https_rewrites = "on"
min_tls_version          = "1.2"
tls_1_3                  = "on"
# endregion

# region HSTS settings (Production: Enabled)
enable_hsts             = true
hsts_max_age            = 31536000
hsts_include_subdomains = true
hsts_preload            = true
# endregion

# region DNS records
dns_records = {
  root = {
    name    = "@"
    type    = "A"
    content = "192.0.2.1"
    proxied = true
  }
  www = {
    name    = "www"
    type    = "CNAME"
    content = "example.com"
    proxied = true
  }
  api = {
    name    = "api"
    type    = "A"
    content = "192.0.2.1"
    proxied = true
  }
}
# endregion

# region WAF custom rules
waf_custom_rules = [
  {
    action      = "block"
    expression  = "(http.request.uri.path contains \"/admin\" and ip.geoip.country ne \"US\")"
    description = "Block non-US access to admin panel"
    enabled     = true
  }
]
# endregion

# region Rate limiting
waf_rate_limits = {
  api_rate_limit = {
    threshold   = 100
    period      = 60
    url_pattern = "*/api/*"
    action_mode = "challenge"
    timeout     = 60
    description = "Rate limit API endpoints"
    disabled    = false
  }
}
# endregion

# region Firewall rules
waf_firewall_rules = {
  block_bad_bots = {
    expression  = "(cf.client.bot) and not (cf.verified_bot_category in {\"Search Engine Crawler\" \"Monitoring & Analytics\"})"
    description = "Block unverified bots"
    action      = "block"
    priority    = 1
    paused      = false
  }
}
# endregion
