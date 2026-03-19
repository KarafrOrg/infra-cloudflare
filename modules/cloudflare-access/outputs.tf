# output "access_group_ids" {
#   description = "Map of access group IDs"
#   value       = { for k, v in cloudflare_access_group.groups : k => v.id }
# }

# output "access_application_ids" {
#   description = "Map of access application IDs"
#   value       = { for k, v in cloudflare_access_application.apps : k => v.id }
# }

# output "access_policy_ids" {
#   description = "Map of access policy IDs"
#   value       = { for k, v in cloudflare_access_policy.policies : k => v.id }
# }
