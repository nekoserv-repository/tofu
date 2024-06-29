terraform {
  required_providers {
    proxmox = {
      source = "bpg/proxmox"
      version = "0.60.1"
    }
  }
}


provider "proxmox" {
  endpoint = "https://${var.proxmox_ve}:8006/api2/json"
  username = var.api_user
  password = var.api_pass
  insecure = true
  tmp_dir  = "/var/tmp"
  ssh {
    agent = true
    node {
      name    = "proxmox"
      address = var.proxmox_ve
    }
  }
}


resource "proxmox_virtual_environment_file" "cloud_image" {
  count        = 1
  content_type = "iso"
  datastore_id = "local"
  node_name    = var.proxmox_host

  source_file {
    path      = "debian-12-genericcloud-amd64.qcow2"
    file_name = "debian-12-genericcloud-amd64.img"
    checksum  = "ef9270aee834900d5195b257d7580dc96483a298bf54e5c0555385dc23036e90"
  }
}


resource "proxmox_virtual_environment_vm" "debian-12-vm" {
  count         = 1
  name          = "debian-12-vm"
  node_name     = var.proxmox_host
  vm_id         = count.index + 250
  tablet_device = "false"
  boot_order    = [ "scsi0" ]

  agent {
    enabled = false
  }

  startup {
    order      = "1"
    up_delay   = "30"
    down_delay = "30"
  }

  cpu {
    cores = 3
  }

  memory {
    dedicated = 8192
  }


  network_device {
    bridge = "vmbr0"
  }

  disk {
    datastore_id = "local-lvm"
    file_id      = proxmox_virtual_environment_file.cloud_image[count.index].id
    interface    = "scsi0"
    size         = 12
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
  }
}
