output "github_idp_id" {
  description = "ID of the GitHub identity provider"
  value       = cloudflare_zero_trust_access_identity_provider.github.id
}

output "access_group_ids" {
  description = "Map of access group IDs"
  value       = { for k, v in cloudflare_zero_trust_access_group.groups : k => v.id }
}

output "access_application_ids" {
  description = "Map of access application IDs"
  value       = { for k, v in cloudflare_zero_trust_access_application.apps : k => v.id }
}

output "access_policy_ids" {
  description = "Map of access policy IDs"
  value       = { for k, v in cloudflare_zero_trust_access_policy.policies : k => v.id }
}
