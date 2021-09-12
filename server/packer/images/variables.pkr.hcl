variable "proxmox_ip" {
  type        = string
  description = "The IP of the proxmox server."
  default     = "192.168.1.124"
}

variable "proxmox_port" {
  type        = string
  description = "The port used by the proxmox management interface."
  default     = "8006"
}

variable "proxmox_username" {
  type        = string
  description = "The user used to connect to proxmox."
  default     = "terraform@pve"
}

variable "proxmox_password" {
  type        = string
  description = "The password for the proxmox user."
  sensitive   = true
  default     = "YOUR PASSWORD HERE"
}

variable "proxmox_node" {
  type        = string
  description = "The name of the proxmox node on which to create the template."
  default     = "server"
}

variable "proxmox_iso_storage_pool" {
  type        = string
  description = "The name of the proxmox storage pool to store ISOs in."
  default     = "local"
}

variable "domain" {
  type        = string
  description = "Domain name for the network."
  default     = "home.waibel.us"
}

variable "nameserver" {
  type        = string
  description = "IP of the nameserver."
  default     = "192.168.1.100"
}

variable "master_node_ip" {
  type        = string
  description = "IP address used by the master k3s node."
  default     = "192.168.1.12"
}

variable "github_username" {
  type        = string
  description = "GitHub username from which to add an authorized SSH key."
  default     = "alexwaibel"
}
