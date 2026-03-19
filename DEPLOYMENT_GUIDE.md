# Terraform Stacks Deployment Guide

## Understanding Deployments

In your new environment-based architecture, each environment (prod/uat/fat) **IS** a deployment. You don't need separate deployment blocks - the environment itself is the deployment unit.

## Deployment Methods

### Method 1: Local Deployment (Recommended for Getting Started)

Each environment stack can be deployed independently using Terraform commands:

```bash
# Deploy Production Environment
cd stacks/prod
terraform init
terraform plan -var-file="prod.tfdeploy.hcl"
terraform apply -var-file="prod.tfdeploy.hcl"

# Or use the Makefile:
make init
make apply
```

### Method 2: Terraform Cloud/Enterprise Stacks

If you're using Terraform Cloud or Terraform Enterprise, you can use the Stacks feature:

1. Create a new Stack in Terraform Cloud
2. Connect your repository
3. Configure the stack to use `stacks/prod/stack.tfstack.hcl`
4. Deploy from the UI

### Method 3: Multiple Deployments per Environment (Advanced)

If you need multiple deployments per environment (e.g., multiple prod deployments for different regions), you can use the `deployments.tfdeploy.hcl` pattern:

```hcl
# stacks/prod/deployments.tfdeploy.hcl

deployment "prod_us" {
  inputs = {
    cloudflare_account_id = "your-account-id"
    domain                = "us.example.com"
    environment           = "prod"
    # ... other inputs
  }
}

deployment "prod_eu" {
  inputs = {
    cloudflare_account_id = "your-account-id"
    domain                = "eu.example.com"
    environment           = "prod"
    # ... other inputs
  }
}
```

## Current Setup: What You Have

Your current setup uses **Method 1** - each environment is deployed independently:

```
stacks/
├── prod/
│   ├── stack.tfstack.hcl        ← Stack definition
│   ├── prod.tfdeploy.hcl        ← Deployment configuration (values)
│   └── ...
├── uat/
│   ├── stack.tfstack.hcl
│   ├── uat.tfdeploy.hcl
│   └── ...
└── fat/
    ├── stack.tfstack.hcl
    ├── fat.tfdeploy.hcl
    └── ...
```

## Quick Deployment

### For Local Development (Recommended)

```bash
# Set your API token
export TF_VAR_cloudflare_api_token="your-token"

# Deploy FAT environment
cd stacks/fat
cp fat.tfdeploy.hcl fat.tfdeploy.local.hcl
# Edit fat.tfdeploy.local.hcl with your values
make init
make apply
```

### For Terraform Cloud

1. Go to Terraform Cloud
2. Create new Stack
3. Point to your repository
4. Select stack configuration: `stacks/prod/stack.tfstack.hcl`
5. Deploy from UI

## Why "No Deployments Found"?

The message "No deployments found" appears because:

1. **You're viewing from Terraform Cloud/Enterprise** - You need to configure the stack in the UI first
2. **Or** - You're looking at the root directory instead of a specific environment

## Next Steps

Choose your deployment method:

### A. Local Deployment (Easiest)

```bash
cd stacks/fat
make init
make apply
```

### B. Terraform Cloud Stacks

1. Configure stack in Terraform Cloud UI
2. Point to `stacks/prod/stack.tfstack.hcl`
3. Deploy from UI

### C. Multiple Deployments Pattern

If you need multiple deployments per environment, let me know and I'll help you set that up.

## Questions?

- **"How do I deploy?"** → Use Method 1 (local) or Method 2 (cloud)
- **"Where are deployment blocks?"** → Not needed with environment-based architecture
- **"Can I have multiple deployments?"** → Yes, use Method 3
- **"Which method should I use?"** → Start with Method 1 (local)

