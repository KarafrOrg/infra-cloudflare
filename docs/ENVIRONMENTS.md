# Environment Configuration Comparison

This document outlines the differences between the three environments (FAT, UAT, PROD) in this infrastructure.

## Overview

| Feature | FAT (Feature Acceptance) | UAT (User Acceptance) | PROD (Production) |
|---------|-------------------------|----------------------|-------------------|
| **Purpose** | Feature testing | User acceptance testing | Live production |
| **SSL Mode** | Flexible | Full | Full Strict |
| **HSTS** | Disabled | Disabled | Enabled (with preload) |
| **WAF Rules** | None | Minimal | Comprehensive |
| **Rate Limiting** | Disabled | Permissive (simulate) | Strict (challenge/block) |
| **Monitoring** | Basic | Standard | Enhanced |

## Detailed Configuration

### FAT (Feature Acceptance Testing)

**Purpose**: Rapid feature testing and development

**Configuration**:
```hcl
environment         = "fat"
domain              = "fat.example.com"
ssl_mode            = "flexible"        # Most permissive
enable_hsts         = false             # Disabled
waf_custom_rules    = []                # No rules
waf_rate_limits     = {}                # No limits
waf_firewall_rules  = {}                # No firewall
```

**When to use**:
- Testing new features before UAT
- Development integration testing
- Quick iteration without security overhead
- Debugging SSL/certificate issues

**Risks**:
- ⚠️ Lower security posture
- ⚠️ Not suitable for sensitive data
- ⚠️ No rate limiting protection

---

### UAT (User Acceptance Testing)

**Purpose**: Pre-production validation with real users

**Configuration**:
```hcl
environment         = "uat"
domain              = "uat.example.com"
ssl_mode            = "full"            # Requires valid cert
enable_hsts         = false             # Disabled for flexibility
waf_custom_rules    = []                # Minimal rules
waf_rate_limits     = {
  api_rate_limit = {
    threshold   = 500               # 5x production
    action_mode = "simulate"        # Logging only
  }
}
```

**When to use**:
- User acceptance testing
- Stakeholder demos
- Performance testing
- Security testing (before prod)

**Characteristics**:
- ✅ More production-like than FAT
- ✅ Rate limiting in simulate mode (logs but doesn't block)
- ⚠️ Still more permissive than production

---

### PROD (Production)

**Purpose**: Live production environment

**Configuration**:
```hcl
environment         = "prod"
domain              = "example.com"
ssl_mode            = "full_strict"     # Strictest mode
enable_hsts         = true              # Full HSTS
hsts_preload        = true              # Browser preload
hsts_max_age        = 31536000          # 1 year

waf_custom_rules = [
  {
    action      = "block"
    expression  = "(http.request.uri.path contains \"/admin\" and ip.geoip.country ne \"US\")"
    description = "Geo-restrict admin panel"
  }
]

waf_rate_limits = {
  api_rate_limit = {
    threshold   = 100
    action_mode = "challenge"           # CAPTCHA challenge
  }
}

waf_firewall_rules = {
  block_bad_bots = {
    action      = "block"
    expression  = "(cf.client.bot) and not (cf.verified_bot_category in {\"Search Engine Crawler\" \"Monitoring & Analytics\"})"
  }
}
```

**Characteristics**:
- ✅ Maximum security
- ✅ HSTS with preload (cannot easily disable)
- ✅ Comprehensive WAF rules
- ✅ Active rate limiting
- ✅ Bot protection

**Before deploying to PROD**:
1. ✅ Test thoroughly in FAT
2. ✅ Validate in UAT with stakeholders
3. ✅ Review all security rules
4. ✅ Verify SSL certificates are valid
5. ✅ Plan for HSTS implications (cannot easily revert)
6. ✅ Have rollback plan ready

---

## SSL/TLS Modes Explained

### Flexible (FAT)
```
Browser ─[HTTPS]─> Cloudflare ─[HTTP]─> Origin Server
```
- Encrypted between browser and Cloudflare
- **Unencrypted** between Cloudflare and origin
- ⚠️ Vulnerable to attacks on origin connection

### Full (UAT)
```
Browser ─[HTTPS]─> Cloudflare ─[HTTPS]─> Origin Server
```
- Encrypted end-to-end
- Origin certificate can be self-signed
- Better security than Flexible

### Full (Strict) (PROD)
```
Browser ─[HTTPS]─> Cloudflare ─[HTTPS]─> Origin Server
                                          (Valid CA cert required)
```
- Encrypted end-to-end
- Origin must have **valid** CA-signed certificate
- Highest security level
- ✅ Recommended for production

---

## HSTS (HTTP Strict Transport Security)

### Disabled (FAT, UAT)
- Browsers will attempt HTTP if HTTPS fails
- Easier to debug connection issues
- Can switch between HTTP/HTTPS easily

### Enabled (PROD)
```hcl
enable_hsts             = true
hsts_max_age            = 31536000      # 1 year
hsts_include_subdomains = true
hsts_preload            = true          # Submit to browser preload list
```

**Implications**:
- 🔒 Browsers will **only** connect via HTTPS
- 🔒 Cannot disable for 1 year (max_age)
- 🔒 Applies to all subdomains
- ⚠️ If HTTPS breaks, site becomes inaccessible
- ⚠️ Preload list is difficult to remove from

**Before enabling in production**:
1. Test thoroughly with HSTS disabled
2. Ensure all subdomains support HTTPS
3. Start with shorter max_age (e.g., 300 seconds)
4. Gradually increase max_age
5. Only enable preload when completely confident

---

## WAF Rules Comparison

### FAT: No Rules
```hcl
waf_custom_rules = []
```
- Unrestricted access
- Easy testing

### UAT: Minimal Rules (Optional)
```hcl
waf_custom_rules = [
  # Could add test rules here
]
```
- Test rules before production
- Validate expressions

### PROD: Comprehensive Protection
```hcl
waf_custom_rules = [
  {
    action      = "block"
    expression  = "(http.request.uri.path contains \"/admin\" and ip.geoip.country ne \"US\")"
    description = "Geo-restrict admin panel"
  },
  {
    action      = "challenge"
    expression  = "(http.request.uri.query contains \"union\" or http.request.uri.query contains \"select\")"
    description = "SQL injection protection"
  }
]
```

---

## Rate Limiting Comparison

| Environment | Threshold | Period | Action Mode | Impact |
|------------|-----------|--------|-------------|--------|
| **FAT** | N/A | N/A | N/A | No limits |
| **UAT** | 500 req | 60s | simulate | Logs only |
| **PROD** | 100 req | 60s | challenge | CAPTCHA |

**Action Modes**:
- `simulate` - Log only, don't block (testing)
- `challenge` - Show CAPTCHA
- `block` - Hard block (strictest)

---

## Deployment Flow

Recommended deployment order:

```
1. FAT (Feature Testing)
   ↓
2. UAT (User Acceptance)
   ↓
3. PROD (Production)
```

### Example Workflow:

1. **Develop feature** → Deploy to FAT
   ```bash
   cd stacks/fat
   make apply
   ```

2. **Test feature** → If passes, deploy to UAT
   ```bash
   cd stacks/uat
   make apply
   ```

3. **User acceptance** → If approved, deploy to PROD
   ```bash
   cd stacks/prod
   make plan  # Review carefully!
   make apply
   ```

---

## Migration Path

When promoting configuration from FAT → UAT → PROD:

### Step 1: Test in FAT
```bash
cd stacks/fat
# Edit fat.tfdeploy.hcl
make apply
# Test feature
```

### Step 2: Promote to UAT
```bash
cd stacks/uat
# Copy relevant config from FAT
# Adjust for UAT settings (more restrictive)
make apply
# User acceptance testing
```

### Step 3: Deploy to PROD
```bash
cd stacks/prod
# Copy validated config from UAT
# Apply production security settings
# Review thoroughly
make plan
# Review the plan carefully!
make apply
```

---

## Quick Reference: DNS Records

All environments use similar DNS structure but point to different IPs:

```hcl
# FAT
dns_records = {
  root = { content = "192.0.2.20" }  # FAT server
}

# UAT
dns_records = {
  root = { content = "192.0.2.10" }  # UAT server
}

# PROD
dns_records = {
  root = { content = "192.0.2.1" }   # PROD server
  www  = { content = "example.com" }
  api  = { content = "192.0.2.1" }
}
```

---

## Security Checklist by Environment

### FAT
- [ ] Basic SSL configured
- [ ] DNS records point to test server
- [ ] No production data

### UAT
- [ ] Valid SSL certificate on origin
- [ ] Rate limiting in simulate mode
- [ ] Stakeholder access configured
- [ ] Similar to prod configuration

### PROD
- [ ] Valid CA-signed SSL certificate
- [ ] HSTS configured (after testing)
- [ ] All WAF rules tested
- [ ] Rate limiting active
- [ ] Bot protection enabled
- [ ] Monitoring configured
- [ ] Backup procedures in place
- [ ] Rollback plan documented

---

## Additional Resources

- [Full README](README.md)
- [Quick Start Guide](QUICKSTART.md)
- [Cloudflare SSL/TLS Documentation](https://developers.cloudflare.com/ssl/)
- [WAF Rules Documentation](https://developers.cloudflare.com/waf/)

