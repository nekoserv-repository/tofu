terraform {
  required_providers {
    proxmox = {
      source = "bpg/proxmox"
      version = "0.42.0"
    }
  }
}


provider "proxmox" {
  endpoint = var.api_url
  username = var.api_user
  password = var.api_pass
  insecure = true
  tmp_dir  = "/var/tmp"
  ssh {
    agent = true
  }
}


resource "proxmox_virtual_environment_file" "debian_cloud_image" {
  content_type = "iso"
  datastore_id = "local"
  node_name    = var.proxmox_host

  source_file {
    path      = "https://cloud.debian.org/images/cloud/bookworm/latest/debian-12-genericcloud-amd64.qcow2"
    file_name = "debian-12-genericcloud-amd64.img"
    checksum  = "16e360b50572092ff5c1ed994285bcca961df28c081b7bb5d7c006d35bce4914"
  }
}


resource "proxmox_virtual_environment_vm" "debian_12" {
  name          = "debian-12-vm"
  node_name     = var.proxmox_host
  vm_id         = "201"
  tablet_device = "false"

  agent {
    enabled   = false
  }

  startup {
    order      = "1"
    up_delay   = "60"
    down_delay = "60"
  }

  cpu {
    cores = 2
  }

  memory {
    dedicated = 2048
  }


  network_device {
    bridge = "vmbr0"
  }

  disk {
    datastore_id = "local-lvm"
    file_id      = proxmox_virtual_environment_file.debian_cloud_image.id
    interface    = "scsi0"
    size         = 4
  }

  serial_device {} # The Debian cloud image expects a serial port to be present

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
  }
}
