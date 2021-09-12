resource "proxmox_vm_qemu" "fileserver" {
  name        = "fileserver"
  target_node = "server"

  clone   = "debian-cloudinit"
  os_type = "cloud-init"
  boot    = "c"

  agent     = 1
  ipconfig0 = "ip=${var.fileserver_ip_address}/24,gw=192.168.1.1"
  sshkeys   = file(var.ssh_public_key)

  provisioner "remote-exec" {
    inline = ["echo provisioned"]

    connection {
      host  = var.fileserver_ip_address
      type  = "ssh"
      user  = "debian"
      agent = true
    }
  }

  provisioner "local-exec" {
    command = "ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook --user debian --inventory '../../ansible/inventory' ../../ansible/playbooks/storage/fileserver.yaml"
  }
}
