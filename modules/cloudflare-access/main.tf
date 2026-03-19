terraform {
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 4.0"
    }
  }
}

# Cloudflare Access Groups - Define who can access applications
resource "cloudflare_zero_trust_access_group" "groups" {
  for_each = var.access_groups

  account_id = var.account_id
  name       = "${each.key}-${var.name_suffix}"

  include {
    email = each.value.emails
  }
}

# Cloudflare Access Policies - Define access rules (created before applications)
resource "cloudflare_zero_trust_access_policy" "policies" {
  for_each = var.access_policies

  account_id = var.account_id
  name       = "${each.key}-${var.name_suffix}"
  decision   = each.value.decision

  include {
    group = [cloudflare_zero_trust_access_group.groups[each.value.group_key].id]
  }
}

# Cloudflare Access Applications - Define what applications are protected
resource "cloudflare_zero_trust_access_application" "apps" {
  for_each = var.access_applications

  account_id       = var.account_id
  type             = "self_hosted"
  name             = "${each.key}-${var.name_suffix}"
  domain           = each.value.domain
  session_duration = try(each.value.session_duration, "24h")

  # Attach policies to this application
  policies = [
    for policy_key, policy in var.access_policies :
    {
      id         = cloudflare_zero_trust_access_policy.policies[policy_key].id
      precedence = policy.precedence
    }
    if policy.app_key == each.key
  ]
}
