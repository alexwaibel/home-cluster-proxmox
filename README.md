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

## Cluster Development

### Prerequisites

- Install the `pre-commit` hooks to ensure linting runs on every commit
- Ensure you have access to the cluster with `kubectl cluster-info`
    - If using k3os, just copy over the config found in `/etc/rancher/k3s/k3s/config` and change the server address
- Ensure USB devices can attach to the node with `kubectl label node $NODE_NAME smarter-device-manager=enabled`

### Provisioning cluster

1. Install the [flux CLI](https://github.com/fluxcd/flux2/)

1. Run `flux check`

1. Set the `GITHUB_TOKEN` env var to a personal access token to your GitHub account

1. Provision cluster with `flux bootstrap github --owner=alexwaibel --repository=home-cluster --private=false --personal=true --path=./cluster`

## Acknowledgements
This cluster has been heavily inspired by the [k8s@home](https://github.com/k8s-at-home) community.
