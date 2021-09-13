## Overview
My homelab Kubernetes cluster in declarative state. [Flux](https://github.com/fluxcd/flux2) automatically deploys any changes to the `/cluster` directory.

## Architecture
The cluster runs on a single [k3s](https://github.com/k3s-io/k3s) node running in a [k3os](https://github.com/rancher/k3os) VM on a single [Proxmox](https://pve.proxmox.com/) host. I'm currently running the entire cluster on my previous desktop machine.

### Virtual Hosts
- k3s (VM)
- NFS fileserver (VM)
- Caddy (LXC)

### Hardware
- 4x12TB HDD
- 32GB DDR4 2400MHz RAM
- Intel i7 6700k
- Nvidia 1070
- HUSBZB-1 Zigbee + Z-Wave Adapter
- Arduino Uno + WS2812B LED strip

### Networking
1. This cluster uses the default Traefik ingress controller deployed by k3s to configure hostnames using a subdomain of my registered tld.
1. Then Caddy (a build with the [Cloudflare module](https://github.com/caddy-dns/cloudflare) included) uses LetsEncrypt to provide certificates for all my services without exposing any ports on my router to the public internet.
1. I then map each hostname to the Caddy server in my DNS server (Pi-hole).

### Storage
I provisioned Proxmox using the ZFS filesystem which provides many benefits including redundancy and snapshots. My current RAID configuration (mirror vdevs, roughly RAID 10) offers 1/2 of my total storage capacity.

Storage for the k3s cluster is provided by the virtualized NFS server. The [NFS Subdirectory External Provisioner Helm chart](https://kubernetes-sigs.github.io/nfs-subdir-external-provisioner/) is used to provision persistent volume claims automatically.

## Installation

The below steps will provision the k3s cluster as well as a reverse proxy and a fileserver.

### Dependencies

- [Terraform](https://learn.hashicorp.com/tutorials/terraform/install-cli?in=terraform/aws-get-started)
    - [Proxmox provisioner](https://registry.terraform.io/providers/Telmate/proxmox/latest/docs) must be added to your `.terraformrc`
- [Packer](https://learn.hashicorp.com/tutorials/packer/get-started-install-cli)
- [Ansible](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html#installing-and-upgrading-ansible-with-pip)
    - Install Ansible dependencies
        ```bash
        ansible-galaxy install -r ansible/requirements.yml
        ```
- [Flux CLI](https://github.com/fluxcd/flux2/)

### Prerequisites

- Install the `pre-commit` hooks to ensure linting runs on every commit
- You must have a server with Proxmox VE installed
    - Must use ZFS for storage
    - Must have sufficient storage space (I use RAID10 with 4x12tb drives)
- You must have a public/private ssh key-pair generated and added to ssh agent

### Provisioning cluster

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
    export TF_VAR_cloudflare_token=(the cloudflare token)
    export GITHUB_TOKEN=(GitHub personal access token)
    ```
1. Double check the [packer config](./server/packer/variables.auto.pkrvars.hcl) and add your proxmox password to the packer secrets file
    ```bash
    echo "proxmox_password = \"YOUR PASSWORD HERE\"" >> server/packer/images/secrets.auto.pkrvars.hcl
    ```
1. Build the template images
    ```bash
    packer build server/packer/images
    ```
1. Check the terraform plan and apply it
    ```bash
    terraform -chdir=server/terraform/proxmox init
    terraform -chdir=server/terraform/proxmox plan
    terraform -chdir=server/terraform/proxmox apply
    ```
1. Once everything's deployed, add local DNS records for the service hostnames from the [Caddy config](./server/ansible/playbooks/proxy/caddy.yaml) and point them all to the proxy server's address

## Acknowledgements
This cluster has been heavily inspired by the [k8s@home](https://github.com/k8s-at-home) community.
