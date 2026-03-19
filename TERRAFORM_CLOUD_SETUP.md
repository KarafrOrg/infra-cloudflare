# Terraform Cloud Stacks Deployment Guide

## ✅ Files Created

I've created `deployments.tfdeploy.hcl` files for all three environments:

- ✅ `stacks/prod/deployments.tfdeploy.hcl` - Production deployment
- ✅ `stacks/uat/deployments.tfdeploy.hcl` - UAT deployment  
- ✅ `stacks/fat/deployments.tfdeploy.hcl` - FAT deployment

## 🚀 How to Deploy in Terraform Cloud

### Step 1: Create a Stack in Terraform Cloud

1. **Log in to Terraform Cloud**: https://app.terraform.io/
2. **Navigate to your Organization**: `KarafrOrg`
3. **Go to Projects** → `karafra-net`
4. **Click "New" → "Stack"**

### Step 2: Configure the Production Stack

**Stack Configuration:**
- **Name**: `infra-cloudflare-prod`
- **Description**: `Production Cloudflare infrastructure`
- **VCS Repository**: `KarafrOrg/infra-cloudflare`
- **Stack Configuration Path**: `stacks/prod`
- **Branch**: `main` (or your default branch)

### Step 3: Set Required Variables

In Terraform Cloud, set these **Terraform Variables**:

| Variable | Value | Sensitive | Description |
|----------|-------|-----------|-------------|
| `cloudflare_api_token` | `your-api-token` | ✅ Yes | Your Cloudflare API token |

**How to set variables:**
1. Go to the Stack → **Variables** tab
2. Click **Add variable**
3. Select **Terraform variable**
4. Enter name: `cloudflare_api_token`
5. Enter your token value
6. Check **Sensitive**
7. Click **Save**

### Step 4: Update Deployment Configuration

Before deploying, you **must** update the values in `deployments.tfdeploy.hcl`:

```bash
# Edit the production deployment file
nano stacks/prod/deployments.tfdeploy.hcl
```

**Update these values:**
- `cloudflare_account_id` - Your actual Cloudflare account ID
- `domain` - Your actual domain (e.g., `karafra.net`)
- DNS record `content` values - Your actual server IPs

**Example:**
```hcl
deployment "production" {
  inputs = {
    cloudflare_account_id = "abc123def456"  # ← Your account ID
    domain                = "karafra.net"    # ← Your domain
    
    dns_records = {
      root = {
        name    = "@"
        type    = "A"
        content = "203.0.113.10"  # ← Your actual IP
        proxied = true
      }
      # ... more records
    }
  }
}
```

### Step 5: Push Changes to Git

```bash
git add stacks/prod/deployments.tfdeploy.hcl
git commit -m "Configure production deployment for Terraform Cloud"
git push origin main
```

### Step 6: Deploy from Terraform Cloud

1. **Go to your Stack** in Terraform Cloud
2. **Click "Deployments"** tab
3. You should now see: **"production"** deployment
4. **Click "Queue plan"** or **"Deploy"**
5. **Review the plan**
6. **Confirm and Apply**

## 📋 Complete Setup for All Environments

### Production Stack

```
Name: infra-cloudflare-prod
Path: stacks/prod
Deployment: production
```

### UAT Stack

```
Name: infra-cloudflare-uat
Path: stacks/uat
Deployment: uat
```

### FAT Stack

```
Name: infra-cloudflare-fat
Path: stacks/fat
Deployment: fat
```

## 🔐 Security Notes

### API Token Permissions

Your Cloudflare API token needs these permissions:
- **Zone** → **Zone Settings** → Edit
- **Zone** → **Zone** → Edit
- **Zone** → **DNS** → Edit
- **Account** → **Account Firewall Access Rules** → Edit
- **Account** → **Account WAF** → Edit

### Best Practices

1. ✅ **Use separate API tokens** for each environment (optional but recommended)
2. ✅ **Mark tokens as sensitive** in Terraform Cloud
3. ✅ **Never commit tokens** to git
4. ✅ **Use RBAC** in Terraform Cloud to control who can deploy

## 📁 File Structure

After creating the deployment files, your structure looks like this:

```
stacks/prod/
├── stack.tfstack.hcl           ← Stack definition
├── variables.tfstack.hcl       ← Variable definitions
├── outputs.tfstack.hcl         ← Outputs
├── prod.tfdeploy.hcl           ← Local deployment config
└── deployments.tfdeploy.hcl    ← Terraform Cloud config ✨ NEW
```

## 🔄 Deployment Workflow

```
1. Update deployments.tfdeploy.hcl
   ↓
2. Commit and push to git
   ↓
3. Terraform Cloud detects changes
   ↓
4. Review plan in TFC UI
   ↓
5. Apply deployment
   ↓
6. Check outputs and verify
```

## 🐛 Troubleshooting

### "No deployments found"

**Cause**: Terraform Cloud can't find `deployments.tfdeploy.hcl`

**Solution**: 
- Ensure the file exists: `stacks/prod/deployments.tfdeploy.hcl`
- Check the Stack Configuration Path is correct: `stacks/prod`
- Push changes to git

### "Invalid configuration"

**Cause**: Syntax error in `deployments.tfdeploy.hcl`

**Solution**:
```bash
cd stacks/prod
terraform init
terraform validate
```

### "Authentication failed"

**Cause**: Missing or invalid `cloudflare_api_token`

**Solution**:
1. Go to Stack → Variables
2. Add `cloudflare_api_token` variable
3. Mark as sensitive
4. Save and retry

### "Zone already exists"

**Cause**: Zone already exists in Cloudflare

**Solution**:
1. Import existing zone first
2. Or use a different domain
3. Or delete the existing zone (careful!)

## 📊 What Gets Deployed

### Production Deployment

- **Domain**: example.com (update to your domain)
- **SSL Mode**: Full Strict
- **HSTS**: Enabled
- **WAF Rules**: Full protection
- **Rate Limiting**: Active (100 req/min)
- **DNS Records**: root, www, api

### UAT Deployment

- **Domain**: uat.example.com
- **SSL Mode**: Full
- **HSTS**: Disabled
- **WAF Rules**: Minimal
- **Rate Limiting**: Permissive (500 req/min, simulate mode)

### FAT Deployment

- **Domain**: fat.example.com
- **SSL Mode**: Flexible
- **HSTS**: Disabled
- **WAF Rules**: None
- **Rate Limiting**: Disabled

## 🎯 Next Steps

1. ✅ Create Production Stack in Terraform Cloud
2. ✅ Set `cloudflare_api_token` variable
3. ✅ Update `deployments.tfdeploy.hcl` with your values
4. ✅ Push to git
5. ✅ Deploy from Terraform Cloud UI
6. ✅ Update nameservers at your domain registrar
7. ✅ Verify deployment

## 📞 Need Help?

- **Terraform Cloud Issues**: [Terraform Cloud Docs](https://developer.hashicorp.com/terraform/cloud-docs)
- **Stacks Issues**: [Terraform Stacks Docs](https://developer.hashicorp.com/terraform/language/stacks)
- **Cloudflare Issues**: [Cloudflare Community](https://community.cloudflare.com/)

---

**Ready to deploy!** 🚀 Go to Terraform Cloud and create your first Stack.

