variable "key_fp" {
  description = "The fingerprint of the GPG key used by SOPS."
  type        = string
  default     = "5BFE57B283EBFAA9C14392882895075AEB2D5149"
}

resource "proxmox_vm_qemu" "k3os_master" {
  name        = "k3os-master"
  target_node = var.proxmox_node
  vmid        = 802

  clone = "k3os-cloudinit"
  agent = 1
  boot  = "c"

  cores  = 2
  memory = 8192

  provisioner "remote-exec" {
    inline = [
      "qm set ${proxmox_vm_qemu.k3os_master.vmid} -usb0 host=10c4:8a2a",
      "qm set ${proxmox_vm_qemu.k3os_master.vmid} -usb1 host=534d:2109",
      "qm set ${proxmox_vm_qemu.k3os_master.vmid} -usb2 host=1a86:7523",
      "qm reboot ${proxmox_vm_qemu.k3os_master.vmid}",
    ]

    connection {
      host  = var.proxmox_ip
      type  = "ssh"
      user  = "root"
      agent = true
    }
  }

  provisioner "remote-exec" {
    inline = [
      "systemctl reboot",
      "echo provisioned",
    ]

    connection {
      host        = var.master_node_ip_address
      type        = "ssh"
      user        = var.k3os_user
      agent       = true
      script_path = "~/is-provisioned.sh"
    }
  }

  provisioner "local-exec" {
    command = "ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook --user ${var.k3os_user} --inventory '../../ansible/inventory' --extra-vars \"key_fp=${var.key_fp} repo_dir=${path.cwd}\" ../../ansible/playbooks/kubernetes/kubernetes.yaml"
  }

  depends_on = [local_file.ansible_inventory]
}
