# Root Stack Setup - Quick Reference

## 🎯 What Was Created

Your infrastructure now has a **minimal, modern root stack** configuration:

```
infra-cloudflare/
├── stack.tfstack.hcl          ✅ Main stack definition
├── providers.tfstack.hcl       ✅ Provider configuration
├── deployments.tfdeploy.hcl    ✅ All deployments (prod/uat/fat)
└── modules/
    ├── cloudflare-dns/
    └── cloudflare-waf/
```

## 📁 File Overview

### `stack.tfstack.hcl` (Main Stack)
- Defines the stack structure
- Declares variables
- Configures components (dns, waf)
- Defines outputs

### `providers.tfstack.hcl` (Provider Config)
- Defines Cloudflare provider
- Centralizes provider version
- Configures authentication

### `deployments.tfdeploy.hcl` (Deployments)
- `production` - Production environment
- `uat` - User Acceptance Testing
- `fat` - Feature Acceptance Testing

## 🚀 Terraform Cloud Setup

### Step 1: Create Stack in TFC

1. Go to Terraform Cloud
2. Create new **Stack**
3. Configure:
   - **Name**: `cloudflare-infrastructure`
   - **Repository**: `KarafrOrg/infra-cloudflare`
   - **Stack Path**: `.` (root directory)
   - **Branch**: `main`

### Step 2: Set Variables

In TFC Stack → Variables:

| Variable | Value | Sensitive |
|----------|-------|-----------|
| `cloudflare_api_token` | Your token | ✅ Yes |

### Step 3: Update Deployments

Edit `deployments.tfdeploy.hcl`:

```hcl
deployment "production" {
  inputs = {
    cloudflare_account_id = "abc123..."  # ← Your account ID
    domain                = "yourdomain.com"  # ← Your domain
    
    dns_records = [
      {
        name    = "www"
        type    = "A"
        value   = "YOUR_IP"  # ← Your server IP
        proxied = true
      }
    ]
  }
}
```

### Step 4: Commit and Push

```bash
git add stack.tfstack.hcl providers.tfstack.hcl deployments.tfdeploy.hcl
git commit -m "Add root stack configuration"
git push origin main
```

### Step 5: Deploy in TFC

1. Go to **Deployments** tab
2. You'll see: `production`, `uat`, `fat`
3. Select deployment
4. Click **Queue plan**
5. Review and **Confirm & Apply**

## 📊 Deployments Overview

| Deployment | Domain | Purpose | WAF Rules |
|------------|--------|---------|-----------|
| **production** | example.com | Live production | Full protection |
| **uat** | uat.example.com | Testing | Minimal rules |
| **fat** | fat.example.com | Development | No rules |

## 🔧 Module Requirements

Your modules need these inputs/outputs:

### `modules/cloudflare-dns/`

**Inputs:**
- `account_id` (string)
- `domain` (string)
- `dns_records` (list of objects)

**Outputs:**
- `zone_id` (string)
- `zone_name` (string)
- `nameservers` (list of strings)

### `modules/cloudflare-waf/`

**Inputs:**
- `zone_id` (string)
- `waf_rules` (list of objects)
- `rate_limiting_rules` (list of objects)

**Outputs:**
- `ruleset_id` (string)

## ✅ What Terraform Cloud Will Show

After setup, you'll see in TFC:

```
📦 Stacks
└── cloudflare-infrastructure
    ├── 🟢 production  (example.com)
    ├── 🟡 uat         (uat.example.com)
    └── 🟡 fat         (fat.example.com)
```

## 🎯 Next Steps

1. ✅ Update `cloudflare_account_id` in `deployments.tfdeploy.hcl`
2. ✅ Update `domain` values
3. ✅ Update DNS record IPs
4. ✅ Commit and push
5. ✅ Create Stack in Terraform Cloud
6. ✅ Set `cloudflare_api_token` variable
7. ✅ Deploy!

## 📝 Notes

- **API Token**: Set in TFC as a sensitive variable, not in deployments
- **Root Stack**: All deployments use the same stack definition
- **Modules**: Must exist in `modules/` directory
- **Schema**: Simplified to minimal required fields

---

**You're ready to deploy!** Push to GitHub and create your Stack in Terraform Cloud.

