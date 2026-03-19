# FAT Environment Configuration
# Update these values with your actual Cloudflare account details

# Cloudflare account settings
cloudflare_account_id = "your-cloudflare-account-id"
domain                = "fat.example.com"
cloudflare_plan       = "free"
environment           = "fat"

# SSL/TLS settings (FAT: Use flexible mode)
ssl_mode                 = "flexible"
always_use_https         = "on"
automatic_https_rewrites = "on"
min_tls_version          = "1.2"
tls_1_3                  = "on"

# HSTS settings (FAT: Disabled)
enable_hsts             = false
hsts_max_age            = 0
hsts_include_subdomains = false
hsts_preload            = false

# DNS records
dns_records = {
  root = {
    name    = "@"
    type    = "A"
    content = "192.0.2.20"
    proxied = true
  }
}

# WAF custom rules (FAT: None)
waf_custom_rules = []

# Rate limiting (FAT: Disabled)
waf_rate_limits = {}

# Firewall rules (FAT: None)
waf_firewall_rules = {}

