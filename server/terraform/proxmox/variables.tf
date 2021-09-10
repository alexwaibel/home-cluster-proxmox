variable "caddy_ip_address" {
  description = "The IP address to be used for Caddy reverse proxy."
  type        = string
  default     = "192.168.1.75"
}

variable "fileserver_ip_address" {
  description = "The IP address to be used for NFS fileserver."
  type        = string
  default     = "192.168.1.250"
}

variable "master_node_ip_address" {
  description = "The IP address to be used for master k3os node."
  type        = string
  default     = "192.168.1.175"
}

variable "ssh_public_key" {
  description = "The location of the SSH public key."
  type        = string
  default     = "~/.ssh/id_rsa.pub"
}

variable "ssh_private_key" {
  description = "The location of the SSH private key."
  type        = string
  default     = "~/.ssh/id_rsa" #tfsec:ignore:GEN001
}
