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
    default = "https://cloud.debian.org/images/cloud/bookworm/20241201-1948/debian-12-genericcloud-amd64-20241201-1948.qcow2"
}
variable "cloud_file_name" {
    default = "debian-12-genericcloud-amd64.img"
}
variable "cloud_checksum" {
    default = "340cdafca262582e2ec013f2118a7daa9003436559a3e1cff637af0fc05d4c3755d43e15470bb40d7dd4430d355b44d098283fc4c7c6f640167667479eeeb0e0"
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
