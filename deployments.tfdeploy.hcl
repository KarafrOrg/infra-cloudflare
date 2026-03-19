store "varset" "credentials" {
  name     = "infra-cloudflare-variables"
  category = "terraform"
}

deployment "production" {
  inputs = {

    cloudflare_account_id = "8a3ba4f6454120fd71c65e87612dd13c"
    cloudflare_api_token  = store.varset.credentials.cloudflare_api_token
    cloudflare_email      = store.varset.credentials.cloudflare_email

    domain = "karafra.net"
    environment = "prod"

    dns_records = {
      "www" = {
        name    = "www"
        type    = "CNAME"
        content = "karafra.net"
        ttl     = 1
        proxied = true
      }
      "api" = {
        name    = "api"
        type    = "CNAME"
        content = "karafra.net"
        ttl     = 1
        proxied = true
      }
    }

    # DNS Configuration
    dns_plan                 = "free"
    ssl_mode                 = "flexible"
    always_use_https         = "on"
    automatic_https_rewrites = "on"
    min_tls_version          = "1.2"
    tls_1_3                  = "on"
    enable_hsts = false

    # WAF Configuration
    waf_custom_rules = [
      {
        description = "Block bad bots"
        expression  = "(cf.client.bot)"
        action      = "block"
        enabled     = true
      }
    ]

    waf_rate_limits = {}
    waf_firewall_rules = {}

    tunnels = {}

    # Access Configuration
    access_groups = {}
    access_applications = {}
    access_policies = {}
  }


}
