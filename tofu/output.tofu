locals {
  bastion     = module.bastion.node
  dns_primary = module.technitium_primary_dns.node
  podman      = module.podman.node

  inventory_content = templatefile("${path.module}/templates/ansible_hosts.tpl", {
    bastion     = local.bastion,
    podman      = local.podman,
    dns_primary = local.dns_primary
  })
}

resource "local_file" "ansible_inventory" {
  content  = local.inventory_content
  filename = "${path.root}/../ansible/inventory/hosts.ini"
}
