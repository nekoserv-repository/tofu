# provider vars
variable "proxmox_api_url" {
}
variable "proxmox_api_token_id" {
}
variable "proxmox_api_token_secret" {
}
variable "proxmox_host" {
  default = "proxmox"
}

# resource vars
variable "hostname" {
  default = "registry"
}
variable "cores" {
   default = "1"
}
variable "memory" {
   default = "256"
}
variable "disk" {
   default = "6144M"
}
variable "storage" {
   default = "local-lvm"
}
variable "template_name" {
    default = "local:vztmpl/alpine-3.20.0.tar.zst"
}
variable "ethernet_name" {
    default = "eth0"
}
variable "bridge_name" {
    default = "vmbr0"
}
variable "vlan_num" {
    default = "-1"
}

# secret vars
variable "ansible_user" {
}
variable "ip_addr" {
}
variable "gw" {
}
variable "ipv6_addr" {
}
variable "ipv6_gw" {
}
variable "public_key_path" {
}
variable "private_key_path" {
}
variable "ssh_key" {
}
