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
   default = "1"
}
variable "memory" {
   default = "1024"
}
variable "disk" {
   default = "1"
}
variable "storage" {
   default = "local-lvm"
}
variable "bridge_name" {
    default = "vmbr0"
}

# cloud vars
variable "cloud_url" {
    default = "https://dl-cdn.alpinelinux.org/alpine/v3.20/releases/cloud/nocloud_alpine-3.20.1-x86_64-bios-cloudinit-r0.qcow2"
}
variable "cloud_file_name" {
    default = "nocloud_alpine-3.20.1-x86_64-bios-cloudinit-r0.img"
}
variable "cloud_checksum" {
    default = "63288e5c1ffa499cfec5bb7f1aac73031aa21a3192faf0f511f8cf579a1edd8761e66e3a9f29bb7b9e9691e3c5108c387629d3c3da8cd24b62ff13bab49190f7"
}

# secret vars
variable "ip_addr" {
}
variable "gw" {
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
