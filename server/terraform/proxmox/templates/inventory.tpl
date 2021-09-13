---

kubernetes:
  hosts:
    master:
      ansible_host: ${master_node_ip}
      ansible_user: ${k3os_user}

proxy:
  hosts:
    caddy:
      ansible_host: ${caddy_ip}
      ansible_user: ${caddy_user}

storage:
  hosts:
    fileserver:
      ansible_host: ${fileserver_ip}
      ansible_user: ${fileserver_user}
