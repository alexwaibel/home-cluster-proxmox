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
  ntp_servers:
  - 0.us.pool.ntp.org
  - 1.us.pool.ntp.org
  k3s_args:
  - server
  - "--disable"
  - "traefik"
  - "--disable"
  - "servicelb"
  - "--disable"
  - "metrics-server"
  - "--disable"
  - "local-storage"
  - "--kube-controller-manager-arg"
  - "address=0.0.0.0"
  - "--kube-controller-manager-arg"
  - "bind-address=0.0.0.0"
  - "--kube-proxy-arg"
  - "metrics-bind-address=0.0.0.0"
  - "--kube-scheduler-arg"
  - "address=0.0.0.0"
  - "--kube-scheduler-arg"
  - "bind-address=0.0.0.0"
  - "--kube-scheduler-arg"
  - "feature-gates=MixedProtocolLBService=true"
  - "--kube-proxy-arg"
  - "feature-gates=MixedProtocolLBService=true"
  - "--kube-controller-manager-arg"
  - "feature-gates=MixedProtocolLBService=true"
  - "--kube-apiserver-arg"
  - "feature-gates=MixedProtocolLBService=true"
  - "--kubelet-arg"
  - "feature-gates=MixedProtocolLBService=true"
  - "--etcd-expose-metrics"
  - "true"
