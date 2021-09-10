source "proxmox" "debian_cloudinit" {
  proxmox_url              = "https://${var.proxmox_ip}:${var.proxmox_port}/api2/json"
  username                 = var.proxmox_username
  password                 = var.proxmox_password
  node                     = var.proxmox_node
  iso_url                  = "https://cdimage.debian.org/debian-cd/current/amd64/iso-cd/debian-11.0.0-amd64-netinst.iso"
  iso_storage_pool         = var.proxmox_iso_storage_pool
  iso_checksum             = "sha512:5f6aed67b159d7ccc1a90df33cc8a314aa278728a6f50707ebf10c02e46664e383ca5fa19163b0a1c6a4cb77a39587881584b00b45f512b4a470f1138eaa1801"
  insecure_skip_tls_verify = true

  cloud_init              = true
  cloud_init_storage_pool = "local-zfs"
  disks {
    disk_size         = "200G"
    storage_pool      = "local-zfs"
    storage_pool_type = "zfspool"
  }
  memory = 2048
  network_adapters {
    model  = "virtio"
    bridge = "vmbr0"
  }
  onboot           = true
  qemu_agent       = true
  scsi_controller  = "virtio-scsi-pci"
  ssh_username     = "debian"
  ssh_password     = "debian"
  ssh_wait_timeout = "10000s"
  template_name    = "debian-cloudinit"
  unmount_iso      = true
  vm_name          = "provisioning-fileserver-template"

  boot_command = [
    "<tab><wait>",
    "priority=critical",
    "<spacebar>",
    "DEBIAN_FRONTEND=text",
    "<spacebar>",
    "auto=true",
    "<spacebar>",
    "url=http://{{ .HTTPIP }}:{{ .HTTPPort }}/debian-preseed.cfg",
    "<enter>"
  ]
  boot_wait      = "10s"
  http_directory = "packer/http"
}

build {
  sources = ["source.proxmox.debian_cloudinit"]
}
