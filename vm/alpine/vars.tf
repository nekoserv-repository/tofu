#Set your public SSH key here
variable "ssh_key" {
}
#Establish which Proxmox host you'd like to spin a VM up on
variable "proxmox_host" {
    default = "proxmox"
}
#Establish which nic you would like to utilize
variable "nic_name" {
    default = "vmbr0"
}
#Establish the VLAN you'd like to use
variable "vlan_num" {
    default = "-1"
}
# proxmox proxmox_ve
variable "proxmox_ve" {
}
# proxmox user
variable "api_user" {
}
# proxmox pass
variable "api_pass" {
}
# security token
variable "token" {
}
# ip_addr
variable "ip_addr" {
}
# gw
variable "gw" {
}
# ipv6_addr
variable "ipv6_addr" {
   default = "none"
}
# ipv6_gw
variable "ipv6_gw" {
   default = "none"
}
# dns1
variable "dns1" {
}
# dns2
variable "dns2" {
}
