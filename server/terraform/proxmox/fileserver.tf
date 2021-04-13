resource "proxmox_vm_qemu" "test-fileserver" {
    name = "test-fileserver"
    target_node="server"

    clone = "VM 9001"
    os_type = "cloud-init"

    ipconfig0 = "ip=192.168.1.250/24,gw=192.168.1.1"
    sshkeys = file("~/.ssh/id_rsa.pub")

    memory = 2048
    agent = 1

    scsihw = "virtio-scsi-pci"

    disk {
        size = "200G"
        type = "scsi"
        storage = "local-zfs"
    }

    network {
        model = "virtio"
        bridge = "vmbr0"
    }
}
