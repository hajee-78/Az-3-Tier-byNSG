# This Terraform configuration sets up an Azure environment with a virtual network, subnets, network security groups, and virtual machines.
# Declares the required providers and their versions, ensuring compatibility with the Azure Resource Manager (azurerm) provider.
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0.2"
    }
  }
  required_version = ">= 1.1.0"
}

# Defines the provider configuration for Azure Resource Manager (azurerm).
# The `features` block is required but can be empty for basic configurations.
provider "azurerm" {
  features {

  }
}

# Calls the network module to create a RG, location, virtual network, address space and subnets.
module "network" {
  source              = "./modules/network"
  resource_group_name = var.resource_group_name
  location            = var.location
  vnet_name           = var.vnet_name
  address_space       = var.address_space
  subnets             = var.subnets
  depends_on          = [var.resource_group_name]
}

# Calls the network security group module to create NSGs and associate them with subnets.
module "nsg" {
  source              = "./modules/nsg"
  resource_group_name = var.resource_group_name
  location            = var.location
  subnet_nsg_map      = var.subnet_nsg_map
  depends_on          = [var.subnets, module.network]
}

# Calls the compute module to create virtual machines in the specified subnets.
module "compute" {
  source              = "./modules/compute"
  resource_group_name = var.resource_group_name
  location            = var.location
  vm_config           = var.vm_config
  depends_on          = [var.resource_group_name, module.network, module.nsg]
}
