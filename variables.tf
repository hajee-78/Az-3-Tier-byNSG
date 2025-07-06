# Define the Resource group name
variable "resource_group_name" {
  type    = string
  default = "rg-3tier"
}
# Define the Azure location for resources
variable "location" {
  type    = string
  default = "Southeast Asia"
}

# Define the Virtual Network (VNet) name
variable "vnet_name" {}
variable "address_space" {
  type = list(string)
}
# Define the subnets within the VNet
variable "subnets" {
  type = map(object({
    name           = string
    address_prefix = string
  }))
}

# define the mapping of subnets to their respective Network Security Groups (NSGs) and rules
variable "subnet_nsg_map" {
  type = map(object({
    nsg_name = string
    rules = list(object({
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
# define the configuration for each virtual machine (VM) in the 3-tier architecture
variable "vm_config" {
  description = "Configuration map for virtual machines"
  type        = any
}