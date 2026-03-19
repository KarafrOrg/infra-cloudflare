deployment "production" {
  inputs = {
    # Authentication - These should be set via environment variables or TFC variables
    cloudflare_api_key    = "" # Set via TFC_VAR_cloudflare_api_key
    cloudflare_email      = "" # Set via TFC_VAR_cloudflare_email
    cloudflare_account_id = "your-cloudflare-account-id"

    domain      = "example.com"
    environment = "prod"

    # DNS Configuration
    dns_plan                 = "free"
    ssl_mode                 = "flexible"
    always_use_https         = "on"
    automatic_https_rewrites = "on"
    min_tls_version          = "1.2"
    tls_1_3                  = "on"
    enable_hsts              = false

    # WAF Configuration
    waf_custom_rules = [
      {
        description = "Block bad bots"
        expression  = "(cf.client.bot)"
        action      = "block"
        enabled     = true
      }
    ]

    waf_rate_limits    = {}
    waf_firewall_rules = {}

    # Tunnel Configuration
    tunnels = {}

    # Access Configuration
    access_groups       = {}
    access_applications = {}
    access_policies     = {}
  }
}

deployment "fat" {
  inputs = {
    # Authentication - These should be set via environment variables or TFC variables
    cloudflare_api_key    = "" # Set via TFC_VAR_cloudflare_api_key
    cloudflare_email      = "" # Set via TFC_VAR_cloudflare_email
    cloudflare_account_id = "your-cloudflare-account-id"

    domain      = "fat.example.com"
    environment = "fat"

    # DNS Configuration
    dns_plan                 = "free"
    ssl_mode                 = "flexible"
    always_use_https         = "on"
    automatic_https_rewrites = "on"
    min_tls_version          = "1.2"
    tls_1_3                  = "on"
    enable_hsts              = false

    # WAF Configuration (FAT: None for testing)
    waf_custom_rules   = []
    waf_rate_limits    = {}
    waf_firewall_rules = {}

    # Tunnel Configuration
    tunnels = {}

    # Access Configuration
    access_groups       = {}
    access_applications = {}
    access_policies     = {}
  }
}

deployment "uat" {
  inputs = {
    # Authentication - These should be set via environment variables or TFC variables
    cloudflare_api_key    = "" # Set via TFC_VAR_cloudflare_api_key
    cloudflare_email      = "" # Set via TFC_VAR_cloudflare_email
    cloudflare_account_id = "your-cloudflare-account-id"

    domain      = "uat.example.com"
    environment = "uat"

    # DNS Configuration
    dns_plan                 = "free"
    ssl_mode                 = "flexible"
    always_use_https         = "on"
    automatic_https_rewrites = "on"
    min_tls_version          = "1.2"
    tls_1_3                  = "on"
    enable_hsts              = false

    # WAF Configuration (UAT: Minimal)
    waf_custom_rules = [
      {
        description = "Block high threat requests"
        expression  = "(cf.threat_score gt 50)"
        action      = "challenge"
        enabled     = true
      }
    ]

    waf_rate_limits    = {}
    waf_firewall_rules = {}

    # Tunnel Configuration
    tunnels = {}

    # Access Configuration
    access_groups       = {}
    access_applications = {}
    access_policies     = {}
  }
}
