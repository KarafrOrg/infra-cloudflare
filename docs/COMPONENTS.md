# Component Reference

## Overview

This document provides detailed technical reference for each Terraform Stack component.

## cloudflare-dns

### Purpose

Manages Cloudflare DNS zones with comprehensive SSL/TLS and security settings.

### Resources

#### cloudflare_zone

Creates and manages a Cloudflare DNS zone.

**Attributes:**
- `account_id` - Cloudflare account identifier
- `zone` - Domain name to manage
- `plan` - Cloudflare plan type (free, pro, business, enterprise)
- `type` - Zone type (full or partial)

#### cloudflare_zone_settings_override

Configures zone-level settings for security and performance.

**Configured Settings:**
- SSL/TLS mode (off, flexible, full, strict)
- Always Use HTTPS (on/off)
- Automatic HTTPS Rewrites (on/off)
- Minimum TLS Version (1.0, 1.1, 1.2, 1.3)
- TLS 1.3 (on/off/zrt)
- HTTP Strict Transport Security (HSTS)

#### cloudflare_record

Creates DNS records in the zone.

**Supported Record Types:**
- A - IPv4 address
- AAAA - IPv6 address
- CNAME - Canonical name
- MX - Mail exchange
- TXT - Text records
- SRV - Service records

### Variables

```terraform
variable "account_id" {
  type        = string
  description = "Cloudflare account ID"
}

variable "domain" {
  type        = string
  description = "Domain name to manage"
}

variable "plan" {
  type        = string
  description = "Cloudflare plan type"
  default     = "free"
}

variable "ssl_mode" {
  type        = string
  description = "SSL/TLS encryption mode"
  default     = "flexible"
}

variable "always_use_https" {
  type        = string
  description = "Redirect HTTP to HTTPS"
  default     = "on"
}

variable "automatic_https_rewrites" {
  type        = string
  description = "Rewrite HTTP URLs to HTTPS"
  default     = "on"
}

variable "min_tls_version" {
  type        = string
  description = "Minimum TLS version"
  default     = "1.2"
}

variable "tls_1_3" {
  type        = string
  description = "Enable TLS 1.3"
  default     = "on"
}

variable "enable_hsts" {
  type        = bool
  description = "Enable HTTP Strict Transport Security"
  default     = false
}
```

### Outputs

```terraform
output "zone_id" {
  description = "Cloudflare zone ID"
  value       = cloudflare_zone.main.id
}

output "zone_name" {
  description = "Zone domain name"
  value       = cloudflare_zone.main.zone
}

output "name_servers" {
  description = "Cloudflare nameservers for the zone"
  value       = cloudflare_zone.main.name_servers
}
```

### Usage Example

```hcl
component "cloudflare_dns" {
  source = "./modules/cloudflare-dns"

  providers = {
    cloudflare = provider.cloudflare.main
  }

  inputs = {
    account_id                = "abc123"
    domain                    = "example.com"
    plan                      = "free"
    ssl_mode                  = "flexible"
    always_use_https          = "on"
    automatic_https_rewrites  = "on"
    min_tls_version           = "1.2"
    tls_1_3                   = "on"
    enable_hsts               = false
  }
}
```

## cloudflare-waf

### Purpose

Implements Web Application Firewall protection using Cloudflare Rulesets API.

### Resources

#### cloudflare_ruleset (Custom WAF Rules)

Creates custom WAF rules for zone protection.

**Configuration:**
- `zone_id` - Target zone
- `kind` - "zone"
- `phase` - "http_request_firewall_custom"
- `rules` - List of rule objects

**Rule Structure:**
```terraform
{
  action      = "block" | "challenge" | "js_challenge" | "allow" | "log"
  expression  = "cf.threat_score > 50"
  description = "Rule description"
  enabled     = true
}
```

#### cloudflare_ruleset (Rate Limiting)

Creates rate limiting rules to prevent abuse.

**Configuration:**
- `zone_id` - Target zone
- `kind` - "zone"
- `phase` - "http_ratelimit"
- `rules` - List of rate limit rules

**Rule Structure:**
```terraform
{
  action      = "block"
  expression  = "(http.request.uri.path eq \"/api/login\")"
  description = "Rate limit login attempts"
  enabled     = true
}
```

#### cloudflare_ruleset (Firewall Rules)

Creates additional firewall rules for fine-grained control.

**Configuration:**
- `zone_id` - Target zone
- `kind` - "zone"
- `phase` - "http_request_firewall_custom"
- `rules` - List of firewall rules

### Variables

```terraform
variable "zone_id" {
  type        = string
  description = "Cloudflare zone ID"
}

variable "name_suffix" {
  type        = string
  description = "Environment suffix"
}

variable "custom_rules" {
  type = list(object({
    action      = string
    expression  = string
    description = string
    enabled     = optional(bool)
  }))
  description = "Custom WAF rules"
  default     = []
}

variable "rate_limits" {
  type = map(object({
    threshold       = number
    period          = number
    expression      = string
    timeout         = optional(number)
    description     = string
    disabled        = optional(bool)
    characteristics = optional(list(string))
  }))
  description = "Rate limiting rules"
  default     = {}
}

variable "firewall_rules" {
  type = map(object({
    expression  = string
    description = string
    action      = string
    priority    = optional(number)
    paused      = optional(bool)
  }))
  description = "Firewall rules"
  default     = {}
}
```

### Outputs

```terraform
output "ruleset_id" {
  description = "WAF ruleset ID"
  value       = cloudflare_ruleset.waf_custom_rules[0].id
}

output "waf_ruleset_id" {
  description = "WAF ruleset ID (alias)"
  value       = cloudflare_ruleset.waf_custom_rules[0].id
}

output "rate_limit_ruleset_id" {
  description = "Rate limiting ruleset ID"
  value       = cloudflare_ruleset.rate_limits[0].id
}

output "firewall_ruleset_id" {
  description = "Firewall ruleset ID"
  value       = cloudflare_ruleset.firewall_rules[0].id
}
```

### WAF Expression Examples

**Block high threat scores:**
```
(cf.threat_score gt 50)
```

**Block specific countries:**
```
(ip.geoip.country in {"CN" "RU"})
```

**Block bad bots:**
```
(cf.client.bot)
```

**Rate limit API endpoints:**
```
(http.request.uri.path eq "/api/login")
```

**Allow only specific IPs:**
```
(ip.src ne 1.1.1.1 and ip.src ne 2.2.2.2)
```

## cloudflare-tunnel

### Purpose

Manages Cloudflare Zero Trust Tunnels for secure application connectivity.

### Resources

#### cloudflare_zero_trust_tunnel_cloudflared

Creates a remotely-managed Cloudflare Tunnel.

**Configuration:**
- `account_id` - Cloudflare account ID
- `name` - Tunnel name
- `config_src` - "cloudflare" (remote management)

#### cloudflare_zero_trust_tunnel_cloudflared_token (data)

Retrieves the tunnel token needed to run cloudflared on servers.

**Usage:**
```bash
cloudflared tunnel run --token <token>
```

#### cloudflare_dns_record

Creates CNAME record pointing to the tunnel.

**Format:**
```
hostname.example.com -> {tunnel-id}.cfargotunnel.com
```

#### cloudflare_zero_trust_tunnel_cloudflared_config

Configures tunnel ingress rules.

**Configuration Structure:**
```terraform
config = {
  ingress = [
    {
      hostname = "app.example.com"
      service  = "http://localhost:8080"
    },
    {
      service = "http_status:404"  # Required catch-all
    }
  ]
}
```

### Variables

```terraform
variable "account_id" {
  type        = string
  description = "Cloudflare account ID"
}

variable "zone_id" {
  type        = string
  description = "Cloudflare zone ID"
}

variable "name_suffix" {
  type        = string
  description = "Environment suffix"
}

variable "tunnels" {
  type = map(object({
    service  = string
    hostname = string
    secret   = string
  }))
  description = "Tunnel configurations"
  default     = {}
}
```

### Outputs

```terraform
output "tunnel_ids" {
  description = "Map of tunnel IDs"
  value       = { for k, v in cloudflare_zero_trust_tunnel_cloudflared.tunnels : k => v.id }
}

output "tunnel_tokens" {
  description = "Map of tunnel tokens"
  value       = { for k, v in data.cloudflare_zero_trust_tunnel_cloudflared_token.tunnel_tokens : k => v.token }
  sensitive   = true
}

output "tunnel_cnames" {
  description = "Map of CNAME records"
  value       = { for k, v in cloudflare_dns_record.tunnel_records : k => v.hostname }
}
```

### Deployment Steps

1. Create tunnel in Cloudflare
2. Retrieve tunnel token
3. Install cloudflared on server
4. Run cloudflared with token
5. Configure ingress rules
6. Test connectivity

### Service URL Formats

**HTTP services:**
```
http://localhost:8080
http://internal-service:3000
```

**HTTPS services:**
```
https://backend:443
```

**Unix sockets:**
```
unix:/var/run/app.sock
```

**TCP services:**
```
tcp://localhost:5432
```

## cloudflare-access

### Purpose

Implements Zero Trust Access policies to protect applications.

### Resources

#### cloudflare_zero_trust_access_group

Defines groups of users who can access applications.

**Configuration:**
```terraform
resource "cloudflare_zero_trust_access_group" "groups" {
  account_id = var.account_id
  name       = "developers-prod"
  
  include = [
    for email in emails : {
      email = {
        email = email
      }
    }
  ]
}
```

**Include Options:**
- Email addresses
- Email domains
- IP ranges
- Countries
- Authentication methods
- Identity provider groups

#### cloudflare_zero_trust_access_policy

Defines access rules and decisions.

**Configuration:**
```terraform
resource "cloudflare_zero_trust_access_policy" "policies" {
  account_id = var.account_id
  name       = "allow-developers"
  decision   = "allow"
  
  include = [
    {
      group = { id = cloudflare_zero_trust_access_group.groups["dev"].id }
    }
  ]
}
```

**Decision Types:**
- `allow` - Grant access
- `deny` - Block access
- `bypass` - Skip authentication
- `non_identity` - Service tokens only

#### cloudflare_zero_trust_access_application

Defines applications to protect.

**Configuration:**
```terraform
resource "cloudflare_zero_trust_access_application" "apps" {
  account_id       = var.account_id
  type             = "self_hosted"
  name             = "app-prod"
  domain           = "app.example.com"
  session_duration = "24h"
  
  policies = [
    {
      id         = cloudflare_zero_trust_access_policy.policies["allow-dev"].id
      precedence = 1
    }
  ]
}
```

**Application Types:**
- `self_hosted` - Behind Cloudflare Tunnel
- `saas` - Third-party SaaS applications
- `ssh` - SSH connections
- `vnc` - VNC connections
- `app_launcher` - App launcher portal

### Variables

```terraform
variable "account_id" {
  type        = string
  description = "Cloudflare account ID"
}

variable "zone_id" {
  type        = string
  description = "Cloudflare zone ID"
}

variable "name_suffix" {
  type        = string
  description = "Environment suffix"
}

variable "access_groups" {
  type = map(object({
    emails = list(string)
  }))
  description = "Access group configurations"
  default     = {}
}

variable "access_applications" {
  type = map(object({
    domain           = string
    session_duration = optional(string)
  }))
  description = "Access application configurations"
  default     = {}
}

variable "access_policies" {
  type = map(object({
    app_key    = string
    group_key  = string
    precedence = number
    decision   = string
  }))
  description = "Access policy configurations"
  default     = {}
}
```

### Outputs

```terraform
output "access_group_ids" {
  description = "Map of access group IDs"
  value       = { for k, v in cloudflare_zero_trust_access_group.groups : k => v.id }
}

output "access_application_ids" {
  description = "Map of access application IDs"
  value       = { for k, v in cloudflare_zero_trust_access_application.apps : k => v.id }
}

output "access_policy_ids" {
  description = "Map of access policy IDs"
  value       = { for k, v in cloudflare_zero_trust_access_policy.policies : k => v.id }
}
```

### Access Flow

1. User navigates to protected domain
2. Cloudflare presents login page
3. User authenticates with email
4. Cloudflare checks access policies
5. If allowed, session token is created
6. User is redirected to application
7. Session valid for configured duration

### Session Duration Options

- `30m` - 30 minutes
- `6h` - 6 hours
- `12h` - 12 hours
- `24h` - 24 hours (default)
- `168h` - 7 days
- `730h` - 30 days

### Policy Precedence

Policies are evaluated in order of precedence (lower number = higher priority):

```
Precedence 1: Allow developers@example.com
Precedence 2: Deny blocked-user@example.com
Precedence 3: Challenge all others
```

## Common Patterns

### Pattern: Multi-tier Access

```hcl
access_groups = {
  "admins" = {
    emails = ["admin@example.com"]
  }
  "developers" = {
    emails = ["dev1@example.com", "dev2@example.com"]
  }
  "viewers" = {
    emails = ["viewer@example.com"]
  }
}

access_applications = {
  "admin-panel" = {
    domain           = "admin.example.com"
    session_duration = "12h"
  }
  "app" = {
    domain           = "app.example.com"
    session_duration = "24h"
  }
}

access_policies = {
  "admins-to-admin-panel" = {
    app_key    = "admin-panel"
    group_key  = "admins"
    precedence = 1
    decision   = "allow"
  }
  "developers-to-app" = {
    app_key    = "app"
    group_key  = "developers"
    precedence = 1
    decision   = "allow"
  }
}
```

### Pattern: Progressive WAF Rules

```hcl
# Development: Log only
waf_custom_rules = [
  {
    action      = "log"
    expression  = "(cf.threat_score gt 50)"
    description = "Log suspicious traffic"
    enabled     = true
  }
]

# Staging: Challenge
waf_custom_rules = [
  {
    action      = "challenge"
    expression  = "(cf.threat_score gt 50)"
    description = "Challenge suspicious traffic"
    enabled     = true
  }
]

# Production: Block
waf_custom_rules = [
  {
    action      = "block"
    expression  = "(cf.threat_score gt 50)"
    description = "Block suspicious traffic"
    enabled     = true
  }
]
```

### Pattern: Tunnel with Access

```hcl
tunnels = {
  "secure-app" = {
    hostname = "app.example.com"
    service  = "http://localhost:8080"
    secret   = "tunnel-secret"
  }
}

access_applications = {
  "secure-app" = {
    domain           = "app.example.com"
    session_duration = "24h"
  }
}

access_policies = {
  "allow-users-to-secure-app" = {
    app_key    = "secure-app"
    group_key  = "authorized-users"
    precedence = 1
    decision   = "allow"
  }
}
```

