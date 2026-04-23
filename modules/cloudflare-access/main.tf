resource "cloudflare_zero_trust_access_identity_provider" "github" {
  name       = "github-idp"
  type       = "github"
  account_id = var.account_id
  config = {
    client_id     = var.github_client_id
    client_secret = var.github_client_secret
  }
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

  include = [
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
