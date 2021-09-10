resource "proxmox_vm_qemu" "k3os" {
  name        = "k3os"
  target_node = "server"

  clone = "k3os-cloudinit"
  agent = 1
  boot  = "c"

  cores  = 2
  memory = 8192
}
