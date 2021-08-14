locals {
  caddy_ip_address      = "192.168.1.75"
  fileserver_ip_address = "192.168.1.250"
  ssh_public_key        = "~/.ssh/id_rsa.pub"
  ssh_private_key       = "~/.ssh/id_rsa" #tfsec:ignore:GEN002
}
