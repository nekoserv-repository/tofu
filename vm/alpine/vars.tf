# provider vars
variable "proxmox_api_endpoint" {
}
variable "proxmox_api_token" {
}
variable "proxmox_ssh_user" {
}
variable "proxmox_node" {
  default = "proxmox"
}

# resource vars
variable "cores" {
   default = "3"
}
variable "memory" {
   default = "4096"
}
variable "disk" {
   default = "16"
}
variable "storage" {
   default = "local-lvm"
}
variable "bridge_name" {
    default = "vmbr0"
}

# cloud vars
variable "cloud_url" {
    default = "https://dl-cdn.alpinelinux.org/alpine/v3.20/releases/cloud/nocloud_alpine-3.20.3-x86_64-bios-cloudinit-r0.qcow2"
}
variable "cloud_file_name" {
    default = "nocloud_alpine-3.20.3-x86_64-bios-cloudinit-r0.img"
}
variable "cloud_checksum" {
    default = "73bd1fdfd9a0b4db250c923630a415a054ed1ae869e6ff4a121b49d28b2fb3a2a21a948bd0c121e5640f3f16c68cfb574b72fd6a4395a788a71f7f279c1c52e3"
}

# secret vars
variable "ipv6_addr" {
}
variable "ipv6_gw" {
}
variable "dns1" {
}
variable "dns2" {
}
variable "public_key_path" {
}
variable "private_key_path" {
}
variable "ssh_key" {
}
