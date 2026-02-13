variable "bw_server" {
  type    = string
  default = "https://vault.hpfr.ch"
}

variable "proxmox_api_url" { type = string }
variable "proxmox_user" { type = string }
variable "proxmox_cluster" { type = string }
variable "proxmox_node" { type = string }

variable "cf_state_access_key_id" { type = string }
variable "cf_state_secret_key" { type = string }
variable "cf_state_bucket_name" {
  type    = string
  default = "schaermu-terraform-state"
}
variable "cf_state_endpoint_url" {
  type    = string
  default = "https://59469c6e9b7a0c72d7efceab1b0152b5.r2.cloudflarestorage.com"
}

variable "infisical_server_url" {
  type    = string
  default = "https://eu.infisical.com"
}
variable "infisical_project_id" { type = string }
variable "infisical_client_id" { type = string }
variable "infisical_client_secret" { type = string }

variable "hosts_technitium_primary_ip" { type = string }
variable "hosts_technitium_secondary_ip" { type = string }
variable "hosts_technitium_tertiary_ip" { type = string }
variable "hosts_podman_ip" { type = string }
variable "hosts_bastion_ip" { type = string }
