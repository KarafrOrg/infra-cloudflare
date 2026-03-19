# Cloudflare Infrastructure with Terraform Stacks

This repository manages Cloudflare infrastructure across multiple environments using Terraform Stacks.

## Architecture

The infrastructure is organized by **environment** rather than by service, making it easier to manage and deploy entire environments at once:

```
infra-cloudflare/
├── stacks/
│   ├── prod/           # Production environment
│   ├── uat/            # User Acceptance Testing environment
│   └── fat/            # Feature Acceptance Testing environment
│
└── modules/            # Reusable Terraform modules
    ├── cloudflare-dns/
    ├── cloudflare-waf/
    ├── cloudflare-tunnel/  (TODO)
    └── cloudflare-access/  (TODO)
```

## Stack Structure

Each environment stack (`prod`, `uat`, `fat`) contains:

- **stack.tfstack.hcl** - Main stack configuration defining all components
- **variables.tfstack.hcl** - Variable definitions for the stack
- **{env}.tfdeploy.hcl** - Deployment configuration with actual values
- **outputs.tfstack.hcl** - Output definitions
- **Makefile** - Helper commands for common operations
- **components/** - Environment-specific component configurations (optional)

## Components

Each stack currently includes:

1. **DNS Component** (`cloudflare-dns` module)
   - Creates and manages Cloudflare zones
   - Manages DNS records
   - Configures SSL/TLS settings
   - Configures HSTS settings

2. **WAF Component** (`cloudflare-waf` module)
   - Custom WAF rules
   - Rate limiting
   - Firewall rules

3. **Tunnels Component** (TODO)
   - Cloudflare Tunnel configurations

4. **Access Component** (TODO)
   - Cloudflare Access policies

## Environment Differences

### Production (`prod`)
- Strict SSL mode (`full_strict`)
- HSTS enabled with preload
- Aggressive WAF rules
- Rate limiting in `challenge` mode

### UAT (`uat`)
- Full SSL mode
- HSTS disabled
- Minimal WAF rules
- Permissive rate limiting in `simulate` mode

### FAT (`fat`)
- Flexible SSL mode
- HSTS disabled
- No WAF rules
- No rate limiting

## Getting Started

### Prerequisites

1. Install [Terraform](https://www.terraform.io/downloads) (v1.7+)
2. Get your [Cloudflare API Token](https://dash.cloudflare.com/profile/api-tokens)
3. Get your Cloudflare Account ID from the dashboard

### Initial Setup

1. Choose an environment to deploy:
   ```bash
   cd stacks/prod  # or uat, fat
   ```

2. Configure your environment:
   ```bash
   cp prod.tfdeploy.hcl prod.tfdeploy.local.hcl
   ```

3. Edit `prod.tfdeploy.local.hcl` with your actual values:
   - `cloudflare_account_id`
   - `domain`
   - DNS records
   - WAF rules (if needed)

4. Export your Cloudflare API token:
   ```bash
   export TF_VAR_cloudflare_api_token="your-api-token"
   ```

### Deployment

Using Make (recommended):

```bash
# Initialize Terraform
make init

# Review changes
make plan

# Apply changes
make apply

# View outputs
make output

# Get zone ID
make get-zone-id

# Get nameservers
make get-nameservers

# Destroy resources
make destroy
```

Using Terraform directly:

```bash
# Initialize
terraform init

# Plan
terraform plan -var-file="prod.tfdeploy.hcl"

# Apply
terraform apply -var-file="prod.tfdeploy.hcl"

# Outputs
terraform output
```

## Component Dependencies

Components within a stack can reference each other:

```hcl
component "waf" {
  source = "../../modules/cloudflare-waf"
  
  inputs = {
    # Reference the zone_id from the dns component
    zone_id = component.dns.zone_id
  }
}
```

This ensures proper ordering and dependency management.

## Adding New Components

### 1. Create a new module

```bash
mkdir -p modules/cloudflare-tunnel
```

Create the module files:
- `main.tf` - Resources
- `variables.tf` - Input variables
- `outputs.tf` - Outputs

### 2. Add component to stack

Edit `stacks/prod/stack.tfstack.hcl`:

```hcl
component "tunnels" {
  source = "../../modules/cloudflare-tunnel"
  
  providers = {
    cloudflare = provider.cloudflare.main
  }
  
  inputs = {
    zone_id     = component.dns.zone_id
    name_suffix = var.environment
    tunnels     = var.tunnels
  }
}
```

### 3. Add variables

Add to `stacks/prod/variables.tfstack.hcl`:

```hcl
variable "tunnels" {
  type = map(object({
    # Define tunnel configuration
  }))
  default = {}
}
```

### 4. Configure deployment

Add to `stacks/prod/prod.tfdeploy.hcl`:

```hcl
tunnels = {
  my_tunnel = {
    # Tunnel configuration
  }
}
```

## Best Practices

1. **API Token Security**
   - Never commit API tokens to version control
   - Use environment variables or secret management
   - The token should have appropriate permissions for your Cloudflare account

2. **State Management**
   - Consider using remote state (S3, Terraform Cloud, etc.)
   - Enable state locking to prevent concurrent modifications
   - Back up state files regularly

3. **Environment Isolation**
   - Each environment has its own state
   - Deploy to lower environments first (fat → uat → prod)
   - Test thoroughly in non-production environments

4. **DNS Configuration**
   - Update nameservers at your domain registrar after deployment
   - Wait for DNS propagation (can take up to 48 hours)
   - Verify with `dig` or `nslookup`

5. **WAF Testing**
   - Use `simulate` mode for rate limits in non-production
   - Test firewall rules thoroughly before production deployment
   - Monitor Cloudflare Analytics for false positives

## Troubleshooting

### Authentication Errors
```bash
# Verify your API token is set
echo $TF_VAR_cloudflare_api_token

# Verify token has correct permissions in Cloudflare dashboard
```

### Zone Already Exists
If you get an error about a zone already existing:
1. Import the existing zone: `terraform import 'component.dns.cloudflare_zone.main' <zone-id>`
2. Or manage it in a different way

### State Issues
```bash
# View current state
terraform state list

# Remove a resource from state
terraform state rm 'component.dns.cloudflare_zone.main'

# Import a resource
terraform import 'component.dns.cloudflare_zone.main' <zone-id>
```

## Migration from Old Structure

If you're migrating from the old `zone`/`waf` separate stacks:

1. **Export current zone ID:**
   ```bash
   cd stacks/zone
   terraform output zone_id > /tmp/zone_id.txt
   ```

2. **Import to new structure:**
   ```bash
   cd ../prod
   make init
   terraform import 'component.dns.cloudflare_zone.main' $(cat /tmp/zone_id.txt)
   ```

3. **Verify plan:**
   ```bash
   make plan
   # Should show minimal changes
   ```

## Contributing

1. Create a feature branch
2. Test in FAT environment first
3. Document any new components or variables
4. Update this README if needed

## Resources

- [Terraform Stacks Documentation](https://developer.hashicorp.com/terraform/language/stacks)
- [Cloudflare Provider Documentation](https://registry.terraform.io/providers/cloudflare/cloudflare/latest/docs)
- [Cloudflare API Documentation](https://developers.cloudflare.com/api/)

