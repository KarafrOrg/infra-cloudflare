terraform {
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 5.0"
    }
  }
}

# TODO: Implement Cloudflare Access resources
# Example structure:
#
# resource "cloudflare_access_group" "groups" {
#   for_each = var.access_groups
#
#   account_id = var.account_id
#   name       = "${each.key}-${var.name_suffix}"
#
#   include {
#     email = each.value.emails
#   }
# }
#
# resource "cloudflare_access_application" "apps" {
#   for_each = var.access_applications
#
#   zone_id          = var.zone_id
#   name             = "${each.key}-${var.name_suffix}"
#   domain           = each.value.domain
#   session_duration = try(each.value.session_duration, "24h")
# }
#
# resource "cloudflare_access_policy" "policies" {
#   for_each = var.access_policies
#
#   application_id = cloudflare_access_application.apps[each.value.app_key].id
#   zone_id        = var.zone_id
#   name           = "${each.key}-${var.name_suffix}"
#   precedence     = each.value.precedence
#   decision       = each.value.decision
#
#   include {
#     group = [cloudflare_access_group.groups[each.value.group_key].id]
#   }
# }
