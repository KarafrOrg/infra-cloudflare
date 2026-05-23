resource "cloudflare_certificate_pack" "edge_certificates" {
  for_each = {
    for cert_key, cert in var.edge_certificates : cert_key => cert
    if try(cert.enabled, true)
  }

  zone_id               = var.zone_id
  type                  = try(each.value.type, "advanced")
  hosts                 = each.value.hosts
  validation_method     = try(each.value.validation_method, "txt")
  validity_days         = try(each.value.validity_days, 90)
  certificate_authority = try(each.value.certificate_authority, "lets_encrypt")
  cloudflare_branding   = try(each.value.cloudflare_branding, false)
}
