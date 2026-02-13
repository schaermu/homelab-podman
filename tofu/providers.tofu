terraform {
  required_version = ">= 1.10.0"

  backend "s3" {
    bucket                      = var.cf_state_bucket_name
    key                         = "terraform.tfstate"
    region                      = "auto"
    skip_credentials_validation = true
    skip_metadata_api_check     = true
    skip_region_validation      = true
    skip_requesting_account_id  = true
    skip_s3_checksum            = true
    use_path_style              = true
    access_key                  = var.cf_state_access_key_id
    secret_key                  = var.cf_state_secret_key
    endpoints                   = { s3 = var.cf_state_endpoint_url }
  }

  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = ">=0.88,<1.0.0"
    }
    bitwarden = {
      source  = "maxlaverse/bitwarden"
      version = ">=0.16.0,<1.0.0"
    }
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = ">=4,<5"
    }
    infisical = {
      version = ">=0.16.0,<1.0.0"
      source  = "infisical/infisical"
    }
    ct = {
      source  = "poseidon/ct"
      version = ">=0.14.0,<1.0.0"
    }
    null = {
      source  = "hashicorp/null"
      version = ">=3.2.4,<4.0.0"
    }
    local = {
      source  = "hashicorp/local"
      version = ">=2.6.1,<3.0.0"
    }
  }
}

ephemeral "infisical_secret" "secrets" {
  for_each     = toset(["BW_EMAIL", "BW_MASTER_PASSWORD", "BW_CLIENT_ID", "BW_CLIENT_SECRET", "PVE_API_TOKEN"])
  name         = each.value
  env_slug     = "prod"
  workspace_id = var.infisical_project_id
  folder_path  = "/_opentofu"
}

locals {
  provider_secrets = {
    bw_email           = ephemeral.infisical_secret.secrets["BW_EMAIL"].value
    bw_master_password = ephemeral.infisical_secret.secrets["BW_MASTER_PASSWORD"].value
    bw_client_id       = ephemeral.infisical_secret.secrets["BW_CLIENT_ID"].value
    bw_client_secret   = ephemeral.infisical_secret.secrets["BW_CLIENT_SECRET"].value
    pve_api_token      = ephemeral.infisical_secret.secrets["PVE_API_TOKEN"].value
  }
}

data "bitwarden_item_ssh_key" "proxmox" {
  search = "terraform@proxmox"
}

provider "bitwarden" {
  email           = local.provider_secrets.bw_email
  master_password = local.provider_secrets.bw_master_password
  client_id       = local.provider_secrets.bw_client_id
  client_secret   = local.provider_secrets.bw_client_secret
  server          = var.bw_server
}

provider "proxmox" {
  endpoint  = var.proxmox_api_url
  api_token = local.provider_secrets.pve_api_token
  insecure  = true

  ssh {
    agent       = false
    private_key = <<EOF
${data.bitwarden_item_ssh_key.proxmox.private_key}
EOF
    username    = var.proxmox_user
  }
}

provider "cloudflare" {
}

provider "infisical" {
  host = var.infisical_server_url
  auth = {
    universal = {
      client_id     = var.infisical_client_id
      client_secret = var.infisical_client_secret
    }
  }
}
