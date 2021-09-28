variable "domain" {
  description = "Network domain name."
  type        = string
}

resource "random_password" "password" {
  length  = 32
  special = true
}

resource "proxmox_lxc" "coredns" {
  hostname    = "coredns"
  target_node = var.proxmox_node
  vmid        = 800

  ostemplate   = "local:vztmpl/debian-11-standard_11.0-1_amd64.tar.gz"
  unprivileged = true
  onboot       = true
  start        = true

  ssh_public_keys = file(var.ssh_public_key)
  password        = random_password.password.result

  cores  = 1
  memory = 512

  rootfs {
    storage = var.proxmox_disk_storage_pool
    size    = "5G"
  }

  network {
    name   = "eth0"
    bridge = "vmbr0"
    ip     = "${var.coredns_ip_address}/24"
    ip6    = "auto"
    gw     = "192.168.1.1"
  }

  provisioner "remote-exec" {
    inline = ["echo provisioned"]

    connection {
      host  = var.coredns_ip_address
      type  = "ssh"
      user  = var.coredns_user
      agent = true
    }
  }

  provisioner "local-exec" {
    command = "ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook --inventory '../../ansible/inventory' --extra-vars \"master_node_ip_address=${var.master_node_ip_address} domain=${var.domain}\" ../../ansible/playbooks/dns/coredns.yaml"
  }

  depends_on = [
    local_file.ansible_inventory,
    proxmox_vm_qemu.k3os_master
  ]
}
