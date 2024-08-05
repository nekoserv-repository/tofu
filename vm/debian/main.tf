terraform {
  required_providers {
    proxmox = {
      source = "bpg/proxmox"
      version = "0.60.1"
    }
  }
}


provider "proxmox" {
  endpoint = "https://${var.proxmox_api_host}:8006/api2/json"
  username = var.proxmox_api_user
  password = var.proxmox_api_pass
  insecure = true
  tmp_dir  = "/var/tmp"
  ssh {
    agent = true
    node {
      name    = "proxmox"
      address = var.proxmox_api_host
    }
  }
}


resource "proxmox_virtual_environment_download_file" "cloud_image" {
  count              = "1"
  content_type       = "iso"
  datastore_id       = "local"
  node_name          = var.proxmox_host
  url                = var.cloud_url
  file_name          = var.cloud_file_name
  checksum           = var.cloud_checksum
  checksum_algorithm = "sha512"
}


resource "proxmox_virtual_environment_vm" "vm" {
  count         = 1
  name          = "debian-12-vm"
  node_name     = var.proxmox_host
  vm_id         = count.index + 250
  tablet_device = "false"
  boot_order    = [ "scsi0" ]

  agent {
    enabled = false
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
    discard      = "on"
    ssd          = true
    size         = var.disk
  }

  # cloud image expects a serial port to be present
  serial_device {}

  operating_system {
    type = "l26" # 6.x - 2.6 Kernel
  }
  initialization {
    ip_config {
      ipv4 {
        address = var.ip_addr
        gateway = var.gw
      }
    }
    user_account {
      keys     = [ var.ssh_key ]
    }
    user_data_file_id = proxmox_virtual_environment_file.cloud_config[count.index].id
  }
}


resource "proxmox_virtual_environment_file" "cloud_config" {
  count        = 1
  content_type = "snippets"
  datastore_id = "local"
  node_name    = var.proxmox_host

  source_raw {
    data = <<EOF
#cloud-config
users:
 - default
 - name: debian
   shell: /bin/bash
   ssh-authorized-keys:
     - ${trimspace(var.ssh_key)}
disable_root: false
EOF
    file_name = "cloud-config-debian-0${count.index}.yaml"
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
