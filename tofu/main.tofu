variable "template_datastore_id" {
  default = "local-bootstrap"
}

variable "datastore_id" {
  default = "local-vms"
}

data "bitwarden_item_ssh_key" "donnerchuebu" {
  search = "schaermu@donnerchuebu"
}

data "bitwarden_item_ssh_key" "klappchuebu" {
  search = "schaermu@klappchuebu"
}

module "podman" {
  source = "./single-vm"
  proxmox = {
    cluster = var.proxmox_cluster
    node    = var.proxmox_node
    api_url = var.proxmox_api_url
  }

  host = {
    name                  = "podman"
    vm_id                 = 100
    datastore_id          = var.datastore_id
    template_datastore_id = var.template_datastore_id
    disk_image_id         = resource.proxmox_virtual_environment_download_file.fedora_server_iso.id
    user_data_file_id     = proxmox_virtual_environment_file.cloud_init_podman.id
    tags                  = ["podman", "container-runtime"]

    specs = {
      cpu       = 16
      memory    = 1024 * 64
      disk_size = 1024
    }

    network = {
      bridge  = "vmbr0"
      ip      = var.hosts_podman_ip
      gateway = "192.168.1.1"
      dns     = ["1.1.1.1", "1.0.0.1"]
    }
  }
}

module "bastion" {
  source = "./single-vm"
  proxmox = {
    cluster = var.proxmox_cluster
    node    = var.proxmox_node
    api_url = var.proxmox_api_url
  }

  host = {
    name                  = "bastion"
    vm_id                 = 120
    datastore_id          = var.datastore_id
    template_datastore_id = var.template_datastore_id
    disk_image_id         = data.proxmox_virtual_environment_file.debian_iso.id
    user_data_file_id     = proxmox_virtual_environment_file.cloud_init_bastion.id
    tags                  = ["bastion", "ssh-access"]

    specs = {
      cpu       = 1
      memory    = 512
      disk_size = 32
    }

    network = {
      bridge  = "vmbr0"
      ip      = var.hosts_bastion_ip
      gateway = "192.168.1.1"
      dns     = ["1.1.1.1", "1.0.0.1"]
    }
  }
}

module "technitium_primary_dns" {
  source = "./single-vm"
  proxmox = {
    cluster = var.proxmox_cluster
    node    = var.proxmox_node
    api_url = var.proxmox_api_url
  }

  host = {
    name                  = "technitium-primary"
    vm_id                 = 130
    datastore_id          = var.datastore_id
    template_datastore_id = var.template_datastore_id
    disk_image_id         = data.proxmox_virtual_environment_file.debian_iso.id
    user_data_file_id     = proxmox_virtual_environment_file.cloud_init_technitium.id
    tags                  = ["technitium", "dns", "primary"]

    specs = {
      cpu       = 1
      memory    = 4096
      disk_size = 32
    }

    network = {
      bridge  = "vmbr0"
      ip      = var.hosts_technitium_primary_ip
      gateway = "192.168.1.1"
      dns     = ["1.1.1.1", "1.0.0.1"]
    }
  }
}
