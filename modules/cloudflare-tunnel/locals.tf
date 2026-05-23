locals {
  tunnels_for_gcp_secret_manager = var.gcp_push_tunnel_tokens ? var.tunnels : {}
}