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


resource "proxmox_virtual_environment_download_file" "cloud_image" {
  count              = "1"
  content_type       = "iso"
  datastore_id       = "local"
  node_name          = var.proxmox_host
  url                = "https://dl-cdn.alpinelinux.org/alpine/v3.20/releases/cloud/nocloud_alpine-3.20.1-x86_64-bios-cloudinit-r0.qcow2"
  file_name          = "nocloud_alpine-3.20.1-x86_64-bios-cloudinit-r0.img"
  checksum           = "63288e5c1ffa499cfec5bb7f1aac73031aa21a3192faf0f511f8cf579a1edd8761e66e3a9f29bb7b9e9691e3c5108c387629d3c3da8cd24b62ff13bab49190f7"
  checksum_algorithm = "sha512"
}


resource "proxmox_virtual_environment_vm" "alpine_template" {
  count         = 1
  name          = "test-0${count.index + 1}"

  node_name     = var.proxmox_host
  vm_id         = count.index + 250
  tablet_device = "false"
  boot_order    = [ "scsi0" ]

  agent {
    enabled = false
  }

  cpu {
    cores = 1
  }

  memory {
    dedicated = 1024
  }


  network_device {
    bridge = "vmbr0"
  }

  disk {
    datastore_id = "local-lvm"
    file_id      = proxmox_virtual_environment_download_file.cloud_image[count.index].id
    interface    = "scsi0"
    discard	 = "on"
    ssd		 = true
    size         = 1
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
  node_name    = var.proxmox_host

  source_raw {
    data = <<EOF
#cloud-config
hostname: test-0${count.index + 1}

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
    file_name = "cloud-config-test-0${count.index}.yaml"
  }
}
