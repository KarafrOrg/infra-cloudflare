deployment "production" {
  inputs = {
    cloudflare_account_id = "your-cloudflare-account-id"
    cloudflare_api_token  = var.cloudflare_api_token  # Set as TFC variable
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
