variable "github_token" {
  description = "The GitHub personal access token used by flux."
  type        = string
  sensitive   = true
}

resource "proxmox_vm_qemu" "k3os-master" {
  name        = "k3os-master"
  target_node = var.proxmox_node

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
      user        = var.k3os_user
      agent       = true
      script_path = "~/is-provisioned.sh"
    }
  }

  provisioner "local-exec" {
    command = "ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook --user ${var.k3os_user} --inventory '../../ansible/inventory' --extra-vars github_token=\"${var.github_token}\" ../../ansible/playbooks/kubernetes/kubernetes.yaml"
  }

  depends_on = [local_file.ansible_inventory]
}
