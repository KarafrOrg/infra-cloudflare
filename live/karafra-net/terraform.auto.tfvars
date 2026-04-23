cloudflare_account_id = "8a3ba4f6454120fd71c65e87612dd13c"

domain      = "karafra.net"
environment = "prod"

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
    threshold       = 1000
    period          = 10
    expression      = "(starts_with(http.request.uri.path, \"api\")) or (cf.waf.credential_check.password_leaked)"
    timeout         = 10
    description     = "Global rate limit for API endpoints and leaked credentials"
    disabled        = false
    characteristics = ["ip.src", "cf.colo.id"]
  }
}

waf_firewall_rules = {}

tunnels = {
  "talos-tunnel" = {
    hostname = "talos.lan.karafra.net"
    service  = "tcp://localhost:50000"
    secret   = "tunnel-secret-app"
  }
}

access_groups = {
  "talos-admins" = {
    github_teams = [
      {
        org  = "KarafrOrg"
        team = "talos-admins"
      }
    ]
    emails = ["mtoth575@gmail.com"]
  }
}

access_applications = {
  "talos-kubernetes-nodes" = {
    domain           = "talos.lan.karafra.net"
    session_duration = "24h"
  }
}

access_policies = {
  "allow-developers-to-talos-nodes" = {
    app_key    = "talos-kubernetes-nodes"
    group_key  = "talos-admins"
    precedence = 1
    decision   = "allow"
  }
}
