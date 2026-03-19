# Terraform Cloud Stacks Deployment Configuration for UAT

deployment "uat" {
  inputs = {
    # Cloudflare account settings
    cloudflare_account_id = "your-cloudflare-account-id"
    domain                = "uat.example.com"
    cloudflare_plan       = "free"
    environment           = "uat"

    # SSL/TLS settings (UAT: Use full mode)
    ssl_mode                 = "full"
    always_use_https         = "on"
    automatic_https_rewrites = "on"
    min_tls_version          = "1.2"
    tls_1_3                  = "on"

    # HSTS settings (UAT: Disabled for flexibility)
    enable_hsts             = false
    hsts_max_age            = 0
    hsts_include_subdomains = false
    hsts_preload            = false

    # DNS records
    dns_records = {
      root = {
        name    = "@"
        type    = "A"
        content = "192.0.2.10"
        proxied = true
      }
      api = {
        name    = "api"
        type    = "A"
        content = "192.0.2.10"
        proxied = true
      }
    }

    # WAF custom rules (UAT: Minimal rules)
    waf_custom_rules = []

    # Rate limiting (UAT: More permissive)
    waf_rate_limits = {
      api_rate_limit = {
        threshold   = 500
        period      = 60
        url_pattern = "*/api/*"
        action_mode = "simulate"
        timeout     = 60
        description = "Rate limit API endpoints - UAT"
        disabled    = false
      }
    }

    # Firewall rules (UAT: Minimal)
    waf_firewall_rules = {}
  }
}

