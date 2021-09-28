variable "proxmox_ip" {
  type        = string
  description = "The IP of the proxmox server."
}

variable "proxmox_username" {
  type        = string
  description = "The user used to connect to proxmox."
}

variable "proxmox_node" {
  type        = string
  description = "The name of the proxmox node."
}

variable "proxmox_disk_storage_pool" {
  type        = string
  description = "The name of the proxmox storage pool to store disks in."
  default     = "local-zfs"
}

variable "ssh_public_key" {
  description = "The location of the SSH public key."
  type        = string
  default     = "~/.ssh/id_rsa.pub"
}

variable "fileserver_ip_address" {
  description = "The IP address to be used for NFS fileserver."
  type        = string
}

variable "fileserver_user" {
  description = "The user account for the fileserver."
  type        = string
  default     = "debian"
}

variable "master_node_ip_address" {
  description = "The IP address to be used for master k3os node."
  type        = string
}

variable "k3os_user" {
  description = "The user for the k3os machine."
  type        = string
  default     = "rancher"
}

variable "coredns_ip_address" {
  description = "The IP address to be used for coredns."
  type        = string
}

variable "coredns_user" {
  description = "The user for the k3os machine."
  type        = string
  default     = "root"
}
