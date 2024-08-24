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
   default = "2"
}
variable "storage" {
   default = "local-lvm"
}
variable "bridge_name" {
    default = "vmbr0"
}

# cloud vars
variable "cloud_url" {
    default = "https://cloud.debian.org/images/cloud/bookworm/20240717-1811/debian-12-genericcloud-amd64-20240717-1811.qcow2"
}
variable "cloud_file_name" {
    default = "debian-12-genericcloud-amd64.img"
}
variable "cloud_checksum" {
    default = "0f0075d53749dba4c9825e606899360626bb20ac6bab3dbdeff40041b051d203eb1a56e68d377c9fac0187faa0aea77fd543ef4a883fff2304eac252cce01b44"
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
