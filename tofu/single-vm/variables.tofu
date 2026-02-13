variable "proxmox" {
  description = "Proxmox VE configuration"
  type = object({
    cluster = string,
    node    = string,
    api_url = string,
  })
}

variable "host" {
  description = "Single VM host configuration"
  type = object({
    name                  = string,
    vm_id                 = number,
    datastore_id          = string,
    template_datastore_id = string,
    disk_image_id         = string
    user_data_file_id     = optional(string)
    tags                  = optional(list(string), [])

    specs = object({
      cpu       = number,
      memory    = number
      disk_size = number
    })

    passthrough_disks = optional(list(string), [])

    network = object({
      bridge  = string,
      ip      = string
      gateway = string,
      dns     = optional(set(string))
    })
  })
}
