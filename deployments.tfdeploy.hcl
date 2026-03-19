deployment "production" {
  inputs = {
    cloudflare_account_id = "your-cloudflare-account-id"
    domain                = "example.com"
    environment           = "prod"

    # DNS Records
    dns_records = [
      {
        name    = "www"
        type    = "A"
        value   = "192.0.2.1"
        proxied = true
      },
      {
        name    = "api"
        type    = "A"
        value   = "192.0.2.2"
        proxied = true
      }
    ]

    # WAF Configuration
    waf_rules = [
      {
        description = "Block bad bots"
        expression  = "(cf.client.bot)"
        action      = "block"
      }
    ]

    rate_limiting_rules = []
  }
}

deployment "fat" {
  inputs = {
    cloudflare_account_id = "your-cloudflare-account-id"
    domain                = "fat.example.com"
    environment           = "fat"

    # DNS records
    dns_records = [
      {
        name    = "@"
        type    = "A"
        value   = "192.0.2.20"
        proxied = true
      }
    ]

    # WAF rules (FAT: None for testing)
    waf_rules = []

    # Rate limiting (FAT: Disabled)
    rate_limiting_rules = []
  }
}

deployment "uat" {
  inputs = {
    cloudflare_account_id = "your-cloudflare-account-id"
    domain                = "uat.example.com"
    environment           = "uat"

    # DNS records
    dns_records = [
      {
        name    = "@"
        type    = "A"
        value   = "192.0.2.10"
        proxied = true
      },
      {
        name    = "api"
        type    = "A"
        value   = "192.0.2.10"
        proxied = true
      }
    ]

    # WAF rules (UAT: Minimal)
    waf_rules = [
      {
        description = "Block high threat requests"
        expression  = "(cf.threat_score gt 50)"
        action      = "challenge"
      }
    ]

    # Rate limiting (UAT: Permissive)
    rate_limiting_rules = []
  }
}
