## Server Setup

This folder contains the Terraform templates and Ansible roles used to provision a new server from scratch.

## Provisioning
1. Install Proxmox VE on the new host
    - Use ZFS for the storage.
    - I use RAID10 with 4x12tb drives
1. Use the k3os ISO remastering script in `/hack` to create a cloud-init compatible k3os image
1. Upload the ISO to Proxmox under `/var/lib/vz/template/iso`
1. Create a user in Proxmox for terraform
    ```bash
    $ pveum user add terraform@pve --password $PASSWORD
    $ pveum aclmod / -user terraform@pve -role Administrator
    ```
1. Download the required debian LXC template
    ```bash
    pveam download local debian-10-standard_10.7-1_amd64.tar.gz
    ```
1. Download the required debian ISO image
    ```bash
    $ cd /var/lib/vz/template/iso
    $ wget http://cdimage.debian.org/cdimage/openstack/current-10/debian-10-openstack-amd64.qcow2
    ```
1. Create cloud-init compatible debian template
    ```bash
    qm create 9000 -name debian-cloudinit --memory 2048 --net0 virtio,bridge=vmbr0
    qm importdisk 9000 debian-10-openstack-amd64.qcow2 local-zfs
    qm set 9000 --scsihw virtio-scsi-pci --scsi0 local-zfs:vm-9000-disk-0
    qm set 9000 --ide2 local-zfs:cloudinit
    qm set 9000 --boot c --bootdisk scsi0
    qm set 9000 --serial0 socket --vga serial0
    qm template 9000
    ```
1. Install terraform CLI on your local machine
1. Add the Proxmox provisioner to your `.terraformrc`
1. Set `$PM_PASS` to your terraform user's password
1. Check the terraform plan and apply it
    ```bash
    $ terraform init
    $ terraform plan
    $ terraform apply
    ```
