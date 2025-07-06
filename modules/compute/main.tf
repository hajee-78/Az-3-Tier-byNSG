
# Gets current Azure subscription ID and subnet ID formatting for use in resource definitions.

data "azurerm_client_config" "current" {}

# Creates a public IP address for each VM that requires one, based on the configuration provided in `vm_config`.
resource "azurerm_public_ip" "pip" {
  for_each            = { for k, v in var.vm_config : k => v if v.public_ip }
  name                = "${each.value.name}-pip"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Dynamic"
  sku                 = "Basic"
}

# Creates a network interface for each VM, associating it with the appropriate subnet and public IP address if specified.
resource "azurerm_network_interface" "nic" {
  for_each            = var.vm_config
  name                = "${each.value.name}-nic"
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = "/subscriptions/${data.azurerm_client_config.current.subscription_id}/resourceGroups/${var.resource_group_name}/providers/Microsoft.Network/virtualNetworks/vnet-3tier/subnets/${each.value.subnet_id}"
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = each.value.public_ip ? azurerm_public_ip.pip[each.key].id : null
  }
}

# Creates a Linux virtual machine for each entry in `vm_config`, configuring it with the specified size, admin credentials, and network interface.
resource "azurerm_linux_virtual_machine" "vm" {
  for_each            = var.vm_config
  name                = each.value.name
  resource_group_name = var.resource_group_name
  location            = var.location
  size                = each.value.vm_size
  admin_username      = each.value.admin_username
  admin_password      = each.value.admin_password
  disable_password_authentication = false
  network_interface_ids = [
    azurerm_network_interface.nic[each.key].id,
  ]

  os_disk {
    name              = "${each.value.name}-osdisk"
    caching           = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
}
