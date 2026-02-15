data "infisical_secrets" "ansible_secrets" {
  env_slug     = "prod"
  workspace_id = var.infisical_project_id
  folder_path  = "/_ansible"
}

locals {
  master_password_hash = bcrypt(data.infisical_secrets.ansible_secrets.secrets["MANAGEMENT_PASSWORD"].value)
}

locals {
  cloud_init_bastion = templatefile("${path.module}/templates/cloud-init.tpl", {
    username      = "schaermu",
    password_hash = local.master_password_hash,
    ssh_keys = [
      data.bitwarden_item_ssh_key.donnerchuebu.public_key,
      data.bitwarden_item_ssh_key.klappchuebu.public_key
    ]
  })
  cloud_init_podman = templatefile("${path.module}/templates/cloud-init.tpl", {
    username      = "podman-user",
    password_hash = local.master_password_hash,
    ssh_keys = [
      data.bitwarden_item_ssh_key.donnerchuebu.public_key,
      data.bitwarden_item_ssh_key.klappchuebu.public_key
    ]
  })
  cloud_init_technitium = templatefile("${path.module}/templates/cloud-init.tpl", {
    username      = "technitium-user",
    password_hash = local.master_password_hash,
    ssh_keys = [
      data.bitwarden_item_ssh_key.donnerchuebu.public_key,
      data.bitwarden_item_ssh_key.klappchuebu.public_key
    ]
  })
}

resource "proxmox_virtual_environment_file" "cloud_init_bastion" {
  node_name    = var.proxmox_node
  datastore_id = var.template_datastore_id
  content_type = "snippets"

  source_raw {
    file_name = "cloud-init-bastion.yaml"
    data      = local.cloud_init_bastion
  }
}

resource "proxmox_virtual_environment_file" "cloud_init_podman" {
  node_name    = var.proxmox_node
  datastore_id = var.template_datastore_id
  content_type = "snippets"

  source_raw {
    file_name = "cloud-init-podman.yaml"
    data      = local.cloud_init_podman
  }
}

resource "proxmox_virtual_environment_file" "cloud_init_technitium" {
  node_name    = var.proxmox_node
  datastore_id = var.template_datastore_id
  content_type = "snippets"

  source_raw {
    file_name = "cloud-init-technitium.yaml"
    data      = local.cloud_init_technitium
  }
}
