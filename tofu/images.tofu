data "proxmox_virtual_environment_file" "debian_iso" {
  node_name    = var.proxmox_node
  datastore_id = var.template_datastore_id
  content_type = "iso"
  file_name    = "debian-13-genericcloud-amd64-shrink.img"
}

resource "proxmox_virtual_environment_download_file" "truenas_iso" {
  node_name    = var.proxmox_node
  datastore_id = var.template_datastore_id
  content_type = "iso"
  url          = "https://download.sys.truenas.net/TrueNAS-SCALE-Fangtooth/25.04.2.6/TrueNAS-SCALE-25.04.2.6.iso"
}

resource "proxmox_virtual_environment_download_file" "fedora_server_iso" {
  node_name    = var.proxmox_node
  datastore_id = var.template_datastore_id
  content_type = "iso"
  file_name    = "Fedora-Cloud-Base-Generic-43-1.6.x86_64.img"
  url          = "https://download.fedoraproject.org/pub/fedora/linux/releases/43/Cloud/x86_64/images/Fedora-Cloud-Base-Generic-43-1.6.x86_64.qcow2"
}
