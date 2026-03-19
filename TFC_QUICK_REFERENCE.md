# ✅ Terraform Cloud Deployment - Quick Reference

## Files Created

```
stacks/prod/deployments.tfdeploy.hcl  ✅ Ready for Terraform Cloud
stacks/uat/deployments.tfdeploy.hcl   ✅ Ready for Terraform Cloud
stacks/fat/deployments.tfdeploy.hcl   ✅ Ready for Terraform Cloud
```

## Quick Setup (5 Steps)

### 1️⃣ Edit Deployment Files

**Update these values in each `deployments.tfdeploy.hcl`:**

```hcl
cloudflare_account_id = "your-actual-account-id"
domain                = "your-actual-domain.com"
```

### 2️⃣ Commit and Push

```bash
git add stacks/*/deployments.tfdeploy.hcl
git commit -m "Add Terraform Cloud deployment configs"
git push origin main
```

### 3️⃣ Create Stack in Terraform Cloud

**Settings:**
- **Name**: `infra-cloudflare-prod`
- **Repository**: `KarafrOrg/infra-cloudflare`
- **Path**: `stacks/prod`
- **Branch**: `main`

### 4️⃣ Set Variables

In Terraform Cloud Stack → Variables:

| Variable | Value | Sensitive |
|----------|-------|-----------|
| `cloudflare_api_token` | `your-token` | ✅ Yes |

### 5️⃣ Deploy

1. Go to **Deployments** tab
2. Click **"production"** deployment
3. Click **"Queue plan"**
4. Review and **Confirm & Apply**

## What You'll See in Terraform Cloud

After pushing your changes:

```
📦 Deployments
├── production     (from stacks/prod/deployments.tfdeploy.hcl)
├── uat           (from stacks/uat/deployments.tfdeploy.hcl)
└── fat           (from stacks/fat/deployments.tfdeploy.hcl)
```

## Deployment Names

| Environment | Deployment Name | File |
|-------------|----------------|------|
| Production | `production` | `stacks/prod/deployments.tfdeploy.hcl` |
| UAT | `uat` | `stacks/uat/deployments.tfdeploy.hcl` |
| FAT | `fat` | `stacks/fat/deployments.tfdeploy.hcl` |

## Before You Deploy

**Update in `deployments.tfdeploy.hcl`:**

- [ ] `cloudflare_account_id` → Your Cloudflare account ID
- [ ] `domain` → Your actual domain
- [ ] DNS `content` values → Your actual IPs
- [ ] WAF rules (optional)

**Get your Cloudflare Account ID:**
1. Log in to Cloudflare Dashboard
2. Go to any zone
3. Look at the right sidebar → Account ID

## Troubleshooting

### ❌ "No deployments found"

**Fix:** Push the `deployments.tfdeploy.hcl` files to git

```bash
git push origin main
```

### ❌ "Authentication failed"

**Fix:** Add `cloudflare_api_token` variable in Terraform Cloud

### ❌ "Invalid syntax"

**Fix:** Validate locally first

```bash
cd stacks/prod
terraform validate
```

## 📖 Full Documentation

- **Complete Guide**: `TERRAFORM_CLOUD_SETUP.md`
- **Deployment Guide**: `DEPLOYMENT_GUIDE.md`
- **Quick Start**: `QUICKSTART.md`

---

**You're all set!** Go to Terraform Cloud and create your Stack. 🚀

