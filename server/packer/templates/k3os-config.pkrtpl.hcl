ssh_authorized_keys:
- github:${github_username}
write_files:
- path: /var/lib/connman/default.config
  content: |-
    [service_eth0]
    Type = ethernet
    IPv4 = ${node_ip}/255.255.255.0/192.168.1.1
    Nameservers = ${nameserver}
- path: /etc/conf.d/qemu-guest-agent
  content: |-
    GA_PATH=/dev/vport2p1
  owner: root
  permissions: '0644'
hostname: ${hostname}

k3os:
  k3os_args:
  - server
  - "--disable=servicelb,traefik,metrics-server"
