variable "master_node_ip_address" {
  description = "The IP address to be used for master k3os node."
  type        = string
}

resource "proxmox_vm_qemu" "k3os-master" {
  name        = "k3os-master"
  target_node = "server"

  clone = "k3os-cloudinit"
  agent = 1
  boot  = "c"

  cores  = 2
  memory = 8192

  provisioner "remote-exec" {
    inline = ["echo provisioned"]

    connection {
      host        = var.master_node_ip_address
      type        = "ssh"
      user        = "rancher"
      agent       = true
      script_path = "~/is-provisioned.sh"
    }
  }

  provisioner "local-exec" {
    command = "ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook --user rancher --inventory '../../ansible/inventory' ../../ansible/playbooks/kubernetes/kubernetes.yaml"
  }
}
