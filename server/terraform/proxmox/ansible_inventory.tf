resource "local_file" "ansible_inventory" {
  content = templatefile("${path.module}/templates/inventory.tpl",
    {
      fileserver_ip   = var.fileserver_ip_address,
      fileserver_user = var.fileserver_user,
      master_node_ip  = var.master_node_ip_address,
      k3os_user       = var.k3os_user
      coredns_ip      = var.coredns_ip_address
      coredns_user    = var.coredns_user
    }
  )
  filename = "../../ansible/inventory/hosts.yml"
}
