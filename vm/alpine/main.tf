terraform {
  required_providers {
    proxmox = {
      source = "bpg/proxmox"
      version = "0.42.1"
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
    path      = "nocloud_alpine-3.19.0-x86_64-bios-cloudinit-r0.qcow2"
    file_name = "nocloud_alpine-3.19.0-x86_64-bios-cloudinit-r0.img"
  }
}


resource "proxmox_virtual_environment_vm" "alpine_vm" {
  count         = 1
  name          = "alpine-vm"
  node_name     = var.proxmox_host
  vm_id         = count.index + 150

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
    dedicated = 1024
  }


  network_device {
    bridge = "vmbr0"
  }

  disk {
    datastore_id = "local-lvm"
    file_id      = proxmox_virtual_environment_file.cloud_image[count.index].id
    interface    = "scsi0"
    size         = 4
  }

  # cloud image expects a serial port to be present
  serial_device {}

  operating_system {
    type = "l26" # 6.x - 2.6 Kernel
  }

  initialization {
    #dns {
    #  servers   = var.dns
    #}
    ip_config {
      ipv4 {
        address = var.ip_addr
        gateway = var.gw
      }
    }
    user_account {
      username  = "alpine"
      keys      = [ var.ssh_key ]
    }
    user_data_file_id = proxmox_virtual_environment_file.cloud_config[count.index].id
  }
}


resource "proxmox_virtual_environment_file" "cloud_config" {
  count        = 1
  content_type = "snippets"
  datastore_id = "local"
  node_name    = var.proxmox_host
  #node_name    = "server-0${count.index + 1}"

  source_raw {
    data = <<EOF
#cloud-config
#hostname: k8s-node-${count.index + 1}
hostname: alpine-vm

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
    # Prevent files overwriting eachother by giving them unique names with the count.index
    file_name = "alpine-terraform-cloud-config-${count.index}.yaml"
  }
}
