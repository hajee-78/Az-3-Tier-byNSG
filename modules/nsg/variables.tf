# Defines the Resource group, location, and VM configuration for the compute module
variable "resource_group_name" {
  type = string
}
variable "location" {
  type = string
}
variable "vnet_name" {
  type = string
  default = "vnet-3tier"
}


variable "subnet_nsg_map" {
  type = map(object({
    nsg_name = string
    rules    = list(object({
      name                       = string
      priority                   = number
      direction                  = string
      access                     = string
      protocol                   = string
      source_port_range          = string
      destination_port_range     = string
      source_address_prefix      = string
      destination_address_prefix = string
    }))
  }))
}
