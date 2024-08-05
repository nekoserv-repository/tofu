# provider vars
variable "proxmox_api_host" {
}
variable "proxmox_api_user" {
}
variable "proxmox_api_pass" {
}
variable "proxmox_host" {
  default = "proxmox"
}

# resource vars
variable "cores" {
   default = "2"
}
variable "memory" {
   default = "2048"
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
