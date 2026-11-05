resource "cloudflare_zero_trust_access_identity_provider" "github" {
  name       = "github-idp"
  type       = "github"
  account_id = var.account_id
  config = {
    client_id     = var.github_client_id
    client_secret = var.github_client_secret
  }
}

resource "cloudflare_zero_trust_device_posture_rule" "warp" {
  count = anytrue([for g in var.access_groups : g.warp]) ? 1 : 0

  account_id  = var.account_id
  name        = "warp-connected-${var.name_suffix}"
  type        = "warp"
  description = "Device is connected through the WARP client"
}

resource "cloudflare_zero_trust_access_group" "groups" {
  for_each = var.access_groups

  account_id = var.account_id
  name       = "${each.key}-${var.name_suffix}"

  include = concat(
    [
      for email in each.value.emails : {
        email = { email = email }
      }
    ],
    each.value.warp ? [{
      device_posture = { integration_uid = cloudflare_zero_trust_device_posture_rule.warp[0].id }
    }] : [],
    each.value.everyone ? [{ everyone = {} }] : [],
    [
      for gh in each.value.github_teams : {
        github_organization = {
          identity_provider_id = cloudflare_zero_trust_access_identity_provider.github.id
          name                 = gh.org
          team                 = try(gh.team, null)
        }
      }
    ]
  )
}

resource "cloudflare_zero_trust_access_policy" "policies" {
  for_each = var.access_policies

  account_id = var.account_id
  name       = "${each.key}-${var.name_suffix}"
  decision   = each.value.decision

  include = each.value.include_everyone ? [{ everyone = {} }] : [
    {
      group = { id = cloudflare_zero_trust_access_group.groups[each.value.group_key].id }
    }
  ]
}

resource "cloudflare_zero_trust_access_application" "apps" {
  for_each = var.access_applications

  account_id       = var.account_id
  type             = "self_hosted"
  name             = "${each.key}-${var.name_suffix}"
  domain           = each.value.domain
  session_duration = try(each.value.session_duration, "24h")

  policies = [
    for policy_key, policy in var.access_policies :
    {
      id         = cloudflare_zero_trust_access_policy.policies[policy_key].id
      precedence = policy.precedence
    }
    if policy.app_key == each.key
  ]
}

resource "cloudflare_zero_trust_device_default_profile" "warp" {
  count = var.warp_split_tunnel_exclude == null ? 0 : 1

  account_id = var.account_id
  exclude    = [for cidr in var.warp_split_tunnel_exclude : { address = cidr }]
}

resource "cloudflare_zero_trust_gateway_policy" "dns_overrides" {
  for_each = var.gateway_dns_overrides

  account_id  = var.account_id
  name        = "${each.key}-${var.name_suffix}"
  description = "Resolve ${join(", ", each.value.domains)} to private IPs for WARP clients"
  enabled     = true
  action      = "override"
  filters     = ["dns"]
  precedence  = 1000 + index(sort(keys(var.gateway_dns_overrides)), each.key)
  traffic     = join(" or ", [for d in each.value.domains : "any(dns.domains[*] == \"${d}\")"])

  rule_settings = {
    override_ips = each.value.ips
  }
}
