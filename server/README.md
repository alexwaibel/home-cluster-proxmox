## Server Setup

This folder contains the Terraform templates and Ansible roles used to provision a new server from scratch.

### Prerequisites

- You must have a server with Proxmox VE installed
    - Must use ZFS for storage
    - Must have sufficient storage space (I use RAID10 with 4x12tb drives)
- You must have a public/private ssh key-pair generated and added to ssh agent

### Dependencies

- Terraform
    - Proxmox provisioner must be added to your `.terraformrc`
- Packer
- Ansible
    - Install Ansible dependencies
        ```bash
        ansible-galaxy install -r ansible/requirements.yml
        ```

### Provisioning
1. Create a user in Proxmox for terraform
    ```bash
    pveum user add terraform@pve --password (the proxmox terraform user password)
    pveum aclmod / -user terraform@pve -role Administrator
    ```
1. Download the required debian LXC template
    ```bash
    pveam download local debian-11-standard_11.0-1_amd64.tar.gz
    ```
1. Set environment variables
    ```bash
    export PKR_VAR_proxmox_password=(the proxmox terraform user password)
    export TF_VAR_cloudflare_token=(the cloudflare token)
    ```
1. Build the template images
    ```bash
    packer build packer/images
    ```
1. Check the terraform plan and apply it
    ```bash
    terraform -chdir=terraform/proxmox init
    terraform -chdir=terraform/proxmox plan
    terraform -chdir=terraform/proxmox apply
    ```
