## Server Setup

This folder contains the Terraform templates and Ansible roles used to provision a new server from scratch.

### Prerequisites

- You must have a server with Proxmox VE installed
    - Must use ZFS for storage
    - Must have sufficient storage space (I use RAID10 with 4x12tb drives)

## Provisioning
1. Use the k3os ISO remastering script in `/hack` to create a cloud-init compatible k3os image
1. Upload the ISO to Proxmox under `/var/lib/vz/template/iso`
1. Create a user in Proxmox for terraform
    ```bash
    pveum user add terraform@pve --password (the proxmox terraform user password)
    pveum aclmod / -user terraform@pve -role Administrator
    ```
1. Download the required debian LXC template
    ```bash
    pveam download local debian-11-standard_11.0-1_amd64.tar.gz
    ```
1. Install terraform CLI and Packer on your local machine
1. Set environment variables
    ```bash
    export PM_PASS=(the proxmox terraform user password)
    export TF_VAR_cloudflare_token=(the cloudflare token)
    ```
1. Run `packer build -var proxmox_password=$PM_PASS fileserver.pkr.hcl`
1. Ensure you have a public/private ssh key-pair generated and added to ssh agent
1. Install ansible dependencies
    ```bash
    ansible-galaxy install -r requirements.yml
    ```
1. Add the Proxmox provisioner to your `.terraformrc`
1. Check the terraform plan and apply it
    ```bash
    $ terraform init
    $ terraform plan
    $ terraform apply
    ```
