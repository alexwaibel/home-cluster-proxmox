---

dns:
  hosts:
    coredns:
      ansible_host: ${coredns_ip}
      ansible_user: ${coredns_user}

kubernetes:
  hosts:
    master:
      ansible_host: ${master_node_ip}
      ansible_user: ${k3os_user}

storage:
  hosts:
    fileserver:
      ansible_host: ${fileserver_ip}
      ansible_user: ${fileserver_user}
