resource "proxmox_vm_qemu" "k3os" {
  name        = "k3os"
  target_node = "server"

  iso = "local:iso/k3os-custom.iso"

  cores  = 2
  memory = 8192
  agent  = 1

  scsihw = "virtio-scsi-pci"

  disk {
    size    = "50G"
    type    = "scsi"
    storage = "local-zfs"
  }

  network {
    model  = "virtio"
    bridge = "vmbr0"
  }
}
