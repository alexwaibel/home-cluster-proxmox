resource "proxmox_vm_qemu" "fileserver" {
  name        = "fileserver"
  target_node = "server"

  clone   = "debian-cloudinit"
  os_type = "cloud-init"

  ipconfig0 = "ip=${local.fileserver_ip_address}/24,gw=192.168.1.1"
  sshkeys   = file("~/.ssh/id_rsa.pub")

  memory = 2048
  agent  = 1

  scsihw = "virtio-scsi-pci"

  disk {
    size    = "200G"
    type    = "scsi"
    storage = "local-zfs"
  }

  network {
    model  = "virtio"
    bridge = "vmbr0"
  }

  provisioner "remote-exec" {
    inline = ["echo provisioned"]

    connection {
      host  = local.fileserver_ip_address
      type  = "ssh"
      user  = "debian"
      agent = true
    }
  }

  provisioner "local-exec" {
    command = "ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook --user debian --inventory '../../ansible/inventory' --private-key ${local.ssh_private_key} ../../ansible/playbooks/storage/fileserver.yaml"
  }
}
