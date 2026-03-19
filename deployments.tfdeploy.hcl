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

    # DNS Configuration
    dns_records = {
      "k8s-node1" = {
        name    = "*"
        type    = "A"
        content = "135.125.223.211"
        ttl     = 1
        proxied = true
      }
      "k8s-node2" = {
        name    = "*"
        type    = "A"
        content = "37.187.159.125"
        ttl     = 1
        proxied = true
      }
      "k8s-node3" = {
        name    = "*"
        type    = "A"
        content = "135.125.223.213"
        ttl     = 1
        proxied = true
      }
      "k8s-node4" = {
        name    = "*"
        type    = "A"
        content = "5.196.78.186"
        ttl     = 1
        proxied = true
      }
      "k8s-node5" = {
        name    = "*"
        type    = "A"
        content = "37.187.157.64"
        ttl     = 1
        proxied = true
      }
      "www" = {
        name    = "www"
        type    = "CNAME"
        content = "karafra.net"
        ttl     = 1
        proxied = true
      }
    }

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
        description = "Block known bots"
        expression  = "(cf.client.bot)"
        action      = "block"
        enabled     = true
      },
      {
        description = "Block requests with SQL injection patterns"
        expression  = "(http.request.uri contains \"'union select'\") or (http.request.uri contains \"'or 1=1'\")"
        action      = "block"
        enabled     = true
      },
      {
        description = "Block XSS attacks"
        expression  = "(http.request.full_uri contains \"'<script>'\") or (http.request.full_uri contains \"'%3Cscript%3E'\")"
        action      = "block"
        enabled     = true
      },
      {
        description = "Block requests with suspicious query strings"
        expression  = "(http.request.uri.query contains \"'base64_encode'\" || http.request.uri.query contains \"'eval('\")"
        action      = "block"
        enabled     = true
      },
      {
        description = "Block requests from specific countries"
        expression  = "(ip.src.country in {\"CN\" \"RU\" \"KP\"})"
        action      = "block"
        enabled     = true
      }
    ]

    waf_rate_limits = {
      "global" = {
        threshold   = 1000
        period      = 60
        expression = "(true)"
        timeout = 60
        description = "Global rate limiting for all requests"
        disabled    = false
      }
    }
    waf_firewall_rules = {}

    tunnels = {}

    # Access Configuration
    access_groups = {}
    access_applications = {}
    access_policies = {}
  }


}
