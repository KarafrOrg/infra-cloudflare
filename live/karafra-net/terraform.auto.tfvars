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
  "kubernetes-api" = {
    name    = "api.k8s.karafra.net"
    type    = "A"
    content = "54.36.168.182"
    ttl     = 1
    proxied = false
  }
}

edge_certificates = {
  kubernetes-oidc = {
    hosts                 = ["oidc.k8s.karafra.net"]
    type                  = "advanced"
    validation_method     = "txt"
    validity_days         = 90
    certificate_authority = "lets_encrypt"
    cloudflare_branding   = false
  }
  kubernetes-general = {
    hosts                 = ["*.kubernetes.karafra.net"]
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
    expression = "(cf.client.bot and not (http.host eq \"argocd-webhook.karafra.net\"))"
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
  private-network = {
    hostname          = "private.karafra.net"
    secret            = "private-network-tunnel-token"
    create_dns_record = false
    cidr_routes       = ["10.96.0.200/32"]
    ingress           = []
  }
  kubernetes-oidc = {
    hostname = "oidc.k8s.karafra.net"
    secret   = "kubernetes-oidc-tunnel-token"
    service  = "https://54.36.168.182:6443"

    ingress = [
      {
        path           = "/.well-known/openid-configuration"
        origin_request = { no_tls_verify = true }
      },
      {
        path           = "/openid/v1/jwks"
        origin_request = { no_tls_verify = true }
      }
    ]
  }
  private-network = {
    hostname          = "private.k8s.karafra.net"
    secret            = "private-network-tunnel-token"
    create_dns_record = false
    ingress           = []
    cidr_routes       = ["10.96.0.200/32"]
  }
}

# Default WARP exclude list with 10.96.0.200/32 (cluster private gateway) carved out of 10.0.0.0/8
# so it is routed through WARP to the private-network tunnel.
warp_split_tunnel_exclude = [
  "10.0.0.0/10",
  "10.64.0.0/11",
  "10.96.0.0/25",
  "10.96.0.128/26",
  "10.96.0.192/29",
  "10.96.0.201/32",
  "10.96.0.202/31",
  "10.96.0.204/30",
  "10.96.0.208/28",
  "10.96.0.224/27",
  "10.96.1.0/24",
  "10.96.2.0/23",
  "10.96.4.0/22",
  "10.96.8.0/21",
  "10.96.16.0/20",
  "10.96.32.0/19",
  "10.96.64.0/18",
  "10.96.128.0/17",
  "10.97.0.0/16",
  "10.98.0.0/15",
  "10.100.0.0/14",
  "10.104.0.0/13",
  "10.112.0.0/12",
  "10.128.0.0/9",
  "100.64.0.0/10",
  "169.254.0.0/16",
  "172.16.0.0/12",
  "192.0.0.0/24",
  "192.168.0.0/16",
  "224.0.0.0/24",
  "240.0.0.0/4",
  "255.255.255.255/32",
  "fe80::/10",
  "fd00::/8",
  "ff01::/16",
  "ff02::/16",
  "ff03::/16",
  "ff04::/16",
  "ff05::/16",
]

# Public DNS for these hosts points at 127.0.0.1 (instant connection refused); WARP clients get the real private IP.
gateway_dns_overrides = {
  private-ingress = {
    domains = ["argocd.kubernetes.karafra.net", "grafana.kubernetes.karafra.net"]
    ips     = ["10.96.0.200"]
  }
}

access_groups = {
  internal = { warp = true }
  public   = { everyone = true }
}

access_applications = {
  internal-kubernetes = {
    domain           = "*.kubernetes.karafra.net"
    session_duration = "24h"
  }
  public-kubernetes-oidc = {
    domain = "oidc.k8s.karafra.net"
  }
}

access_policies = {
  internal-kubernetes = {
    app_key    = "internal-kubernetes"
    group_key  = "internal"
    precedence = 1
    decision   = "allow"
  }
  public-kubernetes-oidc = {
    app_key    = "public-kubernetes-oidc"
    group_key  = "public"
    precedence = 1
    decision   = "bypass"
  }
}
