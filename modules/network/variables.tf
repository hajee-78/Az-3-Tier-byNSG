# Defines the Resource Group, Virtual Network, and Subnets in Azure
variable "resource_group_name" {
  type = string
}
variable "location" {
  type = string
}
variable "vnet_name" {}
variable "address_space" {
  type = list(string)
}
variable "subnets" {
  type = map(object({
    name          = string
    address_prefix = string
  }))
}
