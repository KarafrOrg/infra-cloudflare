# Architecture Overview

## Introduction

This Terraform Stack manages Cloudflare infrastructure including DNS, WAF, Zero Trust Tunnels, and Access policies. The stack is designed to support multiple environments (production, UAT, FAT) with environment-specific configurations.

## Stack Structure

The project follows Terraform Stacks architecture pattern with the following key components:

- **Components**: Reusable infrastructure modules
- **Deployments**: Environment-specific configurations
- **Providers**: Cloudflare provider configuration
- **Variables**: Stack-level input variables

```mermaid
graph TD
    A[Terraform Stack] --> B[Components]
    A --> C[Deployments]
    A --> D[Providers]
    A --> E[Variables]
    
    B --> B1[cloudflare-dns]
    B --> B2[cloudflare-waf]
    B --> B3[cloudflare-tunnel]
    B --> B4[cloudflare-access]
    
    C --> C1[production]
    C --> C2[uat]
    C --> C3[fat]
    
    D --> D1[cloudflare.main]
    
    E --> E1[Authentication]
    E --> E2[DNS Config]
    E --> E3[WAF Config]
    E --> E4[Tunnel Config]
    E --> E5[Access Config]
```

## Component Architecture

### DNS Component

Manages Cloudflare DNS zones and records with SSL/TLS configuration.

```mermaid
graph LR
    A[DNS Component] --> B[Zone Management]
    A --> C[DNS Records]
    A --> D[SSL/TLS Settings]
    
    B --> B1[Zone Creation]
    B --> B2[Zone Settings]
    
    C --> C1[A Records]
    C --> C2[CNAME Records]
    C --> C3[Custom Records]
    
    D --> D1[SSL Mode]
    D --> D2[TLS Version]
    D --> D3[HSTS]
```

### WAF Component

Implements Web Application Firewall rules using Cloudflare Rulesets.

```mermaid
graph TD
    A[WAF Component] --> B[Custom Rules]
    A --> C[Rate Limiting]
    A --> D[Firewall Rules]
    
    B --> B1[cloudflare_ruleset]
    B --> B2[Phase: http_request_firewall_custom]
    
    C --> C1[cloudflare_ruleset]
    C --> C2[Phase: http_ratelimit]
    
    D --> D1[cloudflare_ruleset]
    D --> D2[Phase: http_request_firewall_custom]
    
    B1 --> E[Rules as List Attribute]
    C1 --> E
    D1 --> E
```

### Tunnel Component

Manages Cloudflare Zero Trust Tunnels for secure application access.

```mermaid
graph TD
    A[Tunnel Component] --> B[Tunnel Creation]
    A --> C[DNS Records]
    A --> D[Tunnel Configuration]
    
    B --> B1[cloudflare_zero_trust_tunnel_cloudflared]
    B --> B2[Remote Management]
    
    C --> C1[CNAME Records]
    C --> C2[Points to *.cfargotunnel.com]
    
    D --> D1[Ingress Rules]
    D --> D2[Service Mapping]
    D --> D3[Catch-all 404]
    
    B1 --> E[Tunnel Token]
    E --> F[Deploy on Server]
```

### Access Component

Implements Zero Trust Access policies for application protection.

```mermaid
graph TD
    A[Access Component] --> B[Access Groups]
    A --> C[Access Policies]
    A --> D[Access Applications]
    
    B --> B1[Email-based Members]
    B --> B2[Group Management]
    
    C --> C1[Decision Rules]
    C --> C2[References Groups]
    
    D --> D1[Self-hosted Apps]
    D --> D2[Domain Protection]
    D --> D3[Attached Policies]
    
    B2 --> C2
    C --> D3
```

## Data Flow

### Request Flow with Zero Trust

```mermaid
sequenceDiagram
    participant User
    participant DNS
    participant Tunnel
    participant Access
    participant App
    
    User->>DNS: Request app.example.com
    DNS->>Tunnel: CNAME to tunnel
    Tunnel->>Access: Check Access Policy
    Access->>Access: Verify User Email
    alt Allowed
        Access->>Tunnel: Allow
        Tunnel->>App: Forward Request
        App->>User: Response
    else Denied
        Access->>User: Access Denied
    end
```

### WAF Protection Flow

```mermaid
sequenceDiagram
    participant Client
    participant WAF
    participant CustomRules
    participant RateLimit
    participant Origin
    
    Client->>WAF: HTTP Request
    WAF->>CustomRules: Check Custom Rules
    alt Rule Matches
        CustomRules->>Client: Block/Challenge
    else No Match
        CustomRules->>RateLimit: Continue
        RateLimit->>RateLimit: Check Rate Limit
        alt Limit Exceeded
            RateLimit->>Client: 429 Too Many Requests
        else Within Limit
            RateLimit->>Origin: Forward Request
            Origin->>Client: Response
        end
    end
```

## Deployment Architecture

### Multi-Environment Setup

```mermaid
graph TD
    A[Terraform Stack] --> B[Production]
    A --> C[UAT]
    A --> D[FAT]
    
    B --> B1[app.karafra.net]
    B --> B2[api.karafra.net]
    B --> B3[WAF Rules: Strict]
    B --> B4[Access: Developers]
    
    C --> C1[uat.example.com]
    C --> C2[WAF Rules: Minimal]
    C --> C3[Access: Test Users]
    
    D --> D1[fat.example.com]
    D --> D2[WAF Rules: None]
    D --> D3[Access: Open]
```

## Resource Dependencies

```mermaid
graph TD
    A[providers.tfcomponent.hcl] --> B[components.tfcomponent.hcl]
    C[variables.tfcomponent.hcl] --> B
    
    B --> D[cloudflare-dns]
    B --> E[cloudflare-waf]
    B --> F[cloudflare-tunnel]
    B --> G[cloudflare-access]
    
    D --> D1[zone_id]
    D1 --> E
    D1 --> F
    D1 --> G
    
    G --> G1[access_groups]
    G --> G2[access_policies]
    G --> G3[access_applications]
    
    G1 --> G2
    G2 --> G3
    
    F --> F1[tunnels]
    F --> F2[tunnel_tokens]
    
    E --> E1[waf_ruleset]
    E --> E2[rate_limit_ruleset]
    E --> E3[firewall_ruleset]
```

## Component Inputs and Outputs

### DNS Component

**Inputs:**
- account_id
- domain
- plan
- ssl_mode
- tls_version
- hsts_settings

**Outputs:**
- zone_id
- zone_name
- name_servers

### WAF Component

**Inputs:**
- zone_id
- name_suffix
- custom_rules
- rate_limits
- firewall_rules

**Outputs:**
- ruleset_id
- waf_ruleset_id
- rate_limit_ruleset_id
- firewall_ruleset_id

### Tunnel Component

**Inputs:**
- account_id
- zone_id
- name_suffix
- tunnels (map)

**Outputs:**
- tunnel_ids
- tunnel_tokens (sensitive)
- tunnel_cnames

### Access Component

**Inputs:**
- account_id
- zone_id
- name_suffix
- access_groups
- access_applications
- access_policies

**Outputs:**
- access_group_ids
- access_application_ids
- access_policy_ids

## Security Considerations

### Authentication

All authentication variables are marked as sensitive and ephemeral:
- cloudflare_api_token
- cloudflare_email
- cloudflare_account_id

These should be provided via:
- Terraform Cloud variables
- Environment variables (TFC_VAR_*)
- Secure credential stores

### Zero Trust Architecture

The stack implements Zero Trust principles:
1. All traffic goes through Cloudflare Tunnel
2. No direct exposure of origin servers
3. Access policies enforce authentication
4. Email-based group membership
5. Session duration limits

### WAF Protection

Multiple layers of protection:
1. Custom firewall rules
2. Rate limiting by IP/endpoint
3. Threat score evaluation
4. Bot management
5. Geographic restrictions (optional)

## Naming Conventions

Resources follow consistent naming patterns:

```
{resource_key}-{environment}
```

Examples:
- `app-prod` (tunnel)
- `developers-prod` (access group)
- `Custom WAF Rules - prod` (ruleset)

## Module Structure

Each module follows standard Terraform structure:

```
modules/{module-name}/
├── main.tf         # Resource definitions
├── variables.tf    # Input variables
└── outputs.tf      # Output values
```

## Best Practices

1. **Environment Isolation**: Each deployment is independent
2. **DRY Principle**: Shared logic in components, config in deployments
3. **Sensitive Data**: Never commit secrets to version control
4. **Variable Defaults**: Sensible defaults for optional parameters
5. **Resource Naming**: Consistent naming with environment suffix
6. **Documentation**: Keep docs updated with infrastructure changes

## Troubleshooting

### Common Issues

**Provider Authentication Errors**
- Verify API token has required permissions
- Check account_id is correct
- Ensure token is not expired

**Tunnel Connection Issues**
- Verify tunnel token is correctly deployed
- Check cloudflared service is running
- Validate ingress rules configuration

**Access Policy Conflicts**
- Check policy precedence ordering
- Verify group membership
- Review decision logic (allow/deny)

**WAF False Positives**
- Review custom rule expressions
- Adjust rate limit thresholds
- Use challenge instead of block for testing

