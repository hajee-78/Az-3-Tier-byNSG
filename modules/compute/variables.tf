# Define the Resource group, location, and VM configuration for the compute module
variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}


variable "vm_config" {
  description = "Configuration map for virtual machines"
  type        = any
}
