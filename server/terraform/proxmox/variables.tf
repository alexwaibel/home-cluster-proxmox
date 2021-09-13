variable "ssh_public_key" {
  description = "The location of the SSH public key."
  type        = string
  default     = "~/.ssh/id_rsa.pub"
}
