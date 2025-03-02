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
variable "cpu_type" {
   default = "x86-64-v2-AES"
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
    default = "https://dl-cdn.alpinelinux.org/alpine/v3.21/releases/cloud/nocloud_alpine-3.21.0-x86_64-bios-cloudinit-r0.qcow2"
}
variable "cloud_file_name" {
    default = "alpine-3.21.0.img"
}
variable "cloud_checksum" {
    default = "bb509092cda3548c11bc48a2168ce950d654b50db006e98939c06a5d86487f4e53cbb7954fafbba9ab5c8098008a9f304421ffc3397b0bc1d87b6aa309239b98"
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
variable "timezone" {
}