terraform {
  required_providers {
    proxmox = {
      source = "telmate/proxmox"
      version = "2.9.14"
    }
  }
}

provider "proxmox" {
  pm_api_url = var.proxmox_api_url
  pm_api_token_id = var.proxmox_api_token_id
  pm_api_token_secret = var.proxmox_api_token_secret
  pm_tls_insecure = true
  pm_debug = false
}

resource "proxmox_lxc" "lxc" {
  vmid = 112
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
    ip6 = var.ipv6_addr
    gw6 = var.ipv6_gw
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

locals {
  ip_addr = replace("${var.ip_addr}", "/\\/24.*/", "")
}

resource "null_resource" "ansible" {
  triggers = {
    always_run = "${timestamp()}"
  }
  provisioner "local-exec" {
    command = "ANSIBLE_FORCE_COLOR=True ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -u ${var.ansible_user} --inventory=\"${local.ip_addr},\" -l ${local.ip_addr} --private-key ${var.private_key_path} -e 'pub_key=${var.public_key_path}' --ssh-extra-args '-o UserKnownHostsFile=/dev/null' -e @secrets.enc main.yml"
  }
  depends_on = [ proxmox_lxc.lxc ]
}
