terraform {
  required_providers {
    proxmox = {
      source = "bpg/proxmox"
      version = "0.66.3"
    }
  }
}


provider "proxmox" {
  endpoint  = var.proxmox_api_endpoint
  api_token = var.proxmox_api_token
  insecure  = true
  tmp_dir  = "/var/tmp"
  ssh {
    agent    = true
    username = var.proxmox_ssh_user
  }
}


resource "proxmox_virtual_environment_download_file" "cloud_image" {
  count              = "1"
  content_type       = "iso"
  datastore_id       = "local"
  node_name          = var.proxmox_node
  url                = var.cloud_url
  file_name          = var.cloud_file_name
  checksum           = var.cloud_checksum
  checksum_algorithm = "sha512"
}


resource "proxmox_virtual_environment_vm" "vm" {
  count         = 1
  name          = "test-0${count.index+1}"

  node_name     = var.proxmox_node
  vm_id         = count.index + 250
  tablet_device = "false"
  boot_order    = [ "scsi0" ]

  agent {
    enabled = true
  }

  cpu {
    cores = var.cores
  }

  memory {
    dedicated = var.memory
  }

  network_device {
    bridge = var.bridge_name
  }

  disk {
    datastore_id = var.storage
    file_id      = proxmox_virtual_environment_download_file.cloud_image[count.index].id
    interface    = "scsi0"
    discard	 = "on"
    ssd		 = true
    size         = var.disk
    cache        = "writethrough"
  }

  serial_device {}

  operating_system {
    type = "l26"
  }

  initialization {
    ip_config {
      ipv4 {
        address = var.ip_addr
        gateway = var.gw
      }
    }
    user_data_file_id = proxmox_virtual_environment_file.cloud_config[count.index].id
  }
}


resource "proxmox_virtual_environment_file" "cloud_config" {
  count        = 1
  content_type = "snippets"
  datastore_id = "local"
  node_name    = var.proxmox_node

  source_raw {
    data = <<EOF
#cloud-config
hostname: test-0${count.index+1}

manage_resolv_conf: true
resolv_conf:
  nameservers:
    - "${var.dns1}"
    - "${var.dns2}"

users:
  - default
  - name: alpine
    shell: /bin/ash
    ssh-authorized-keys:
      - ${trimspace(var.ssh_key)}
    sudo: ALL=(ALL) NOPASSWD:ALL

write_files:
  - path: /etc/sudoers.d/cloud-init
    content: |
      Defaults !requiretty

package_update: true
package_upgrade: true
packages:
  - qemu-guest-agent

runcmd:
  - rc-update add qemu-guest-agent default
  - rc-service qemu-guest-agent start

EOF
    file_name = "cloud-config-test-0${count.index+1}.yaml"
  }
}

locals {
  ip_addr = replace("${var.ip_addr}", "/\\/.*/", "")
}

resource "null_resource" "ansible" {
  triggers = {
    always_run = "${timestamp()}"
  }
  provisioner "local-exec" {
    command = "ANSIBLE_FORCE_COLOR=True ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook --inventory=\"${local.ip_addr},\" -l ${local.ip_addr} --private-key ${var.private_key_path} -e 'pub_key=${var.public_key_path}' --ssh-extra-args '-o UserKnownHostsFile=/dev/null' main.yml"
  }
  depends_on = [ proxmox_virtual_environment_vm.vm ]
}
