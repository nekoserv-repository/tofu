terraform {
  required_providers {
    proxmox = {
      source = "telmate/proxmox"
      version = "2.9.14"
    }
  }
}

provider "proxmox" {
  pm_api_url = var.api_url
  pm_api_token_id = var.token_id
  pm_api_token_secret = var.token_secret
  pm_tls_insecure = true
  pm_debug = false
}

resource "proxmox_lxc" "lxc-container" {
  vmid = 111
  onboot = true
  unprivileged = true
  target_node = var.proxmox_host
  cores = var.cores
  memory = var.memory
  hostname = var.hostname
  network  {
    name = var.ethernet_name
    bridge = var.bridge_name
    ip = var.ip_addr
    gw = var.gw
  }
  start = true
  ostemplate = var.template_name
  rootfs {
    storage = var.storage
    size = var.disk
  }
  ssh_public_keys = <<EOT
  ${var.ssh_key}
  EOT
}
