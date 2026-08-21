locals {
  tunnel_ingress = {
    for tunnel_key, tunnel in var.tunnels : tunnel_key => (
      tunnel.ingress != null
      ? [
      for rule in tunnel.ingress : {
        hostname = coalesce(rule.hostname, tunnel.hostname)
        path     = rule.path
        service  = coalesce(rule.service, tunnel.service)

        origin_request = rule.origin_request
      }
    ]
      : [
      {
        hostname = tunnel.hostname
        path     = null
        service  = tunnel.service

        origin_request = {
          no_tls_verify = tunnel.no_tls_verify
        }
      }
    ]
    )
  }

  tunnels_for_gcp_secret_manager = {
    for tunnel_key, tunnel in var.tunnels :
    tunnel_key => tunnel
  }
}
