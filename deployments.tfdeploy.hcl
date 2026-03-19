deployment "production" {
  inputs = {

    domain = "example.com"
    environment = "prod"

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

    # Tunnel Configuration
    tunnels = {}

    # Access Configuration
    access_groups = {}
    access_applications = {}
    access_policies = {}
  }
}
