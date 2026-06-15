cloudflare_account_id = "8a3ba4f6454120fd71c65e87612dd13c"

domain      = "karafra.net"
environment = "prod"

gcp_push_tunnel_tokens         = true
gcp_tunnel_token_secret_prefix = "cloudflare-tunnel-token-"
gcp_secret_labels = {
  managed_by = "terraform"
  stack      = "infra-cloudflare"
  env        = "prod"
}

dns_records = {
  "www" = {
    name    = "www"
    type    = "CNAME"
    content = "karafra.net"
    ttl     = 1
    proxied = true
  }
}

edge_certificates = {
  kubernetes-api = {
    hosts                 = ["kuberenetes.karafra.net"]
    type                  = "advanced"
    validation_method     = "txt"
    validity_days         = 90
    certificate_authority = "lets_encrypt"
    cloudflare_branding   = false
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
  kubernetes-api = {
    hostname          = "kubernetes.karafra.net"
    service           = "https://10.200.0.10:6443"
    secret            = "kubernetes-api-tunnel-token"
    create_dns_record = true
    cidr_routes       = []
    no_tls_verify     = true
  }
}

access_groups = {}

access_applications = {
  kubernetes-api = {
    domain           = "kubernetes.karafra.net"
    session_duration = "24h"
  }
}

access_policies = {
  allow-everyone-to-kubernetes-api = {
    app_key          = "kubernetes-api"
    precedence       = 1
    include_everyone = true
    decision         = "bypass"
  }
}
