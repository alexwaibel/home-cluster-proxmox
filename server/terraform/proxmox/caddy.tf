resource "random_password" "password" {
  length  = 32
  special = true
}

resource "proxmox_lxc" "caddy" {
  hostname    = "caddy-test"
  target_node = "server"

  ostemplate   = "local:vztmpl/debian-10-standard_10.7-1_amd64.tar.gz"
  unprivileged = true
  onboot       = true
  start        = true

  ssh_public_keys = file("~/.ssh/id_rsa.pub")
  password        = random_password.password.result

  cores  = 1
  memory = 512

  rootfs {
    storage = "local-zfs"
    size    = "10G"
  }

  network {
    name   = "eth0"
    bridge = "vmbr0"
    ip     = "192.168.1.75/24"
    ip6    = "auto"
  }
}
