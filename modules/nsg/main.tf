# Defines the Network Security Groups (NSGs) and their associations with subnets in Azure
resource "azurerm_network_security_group" "nsg" {
  for_each            = var.subnet_nsg_map
  name                = each.value.nsg_name
  location            = var.location
  resource_group_name = var.resource_group_name

  dynamic "security_rule" {
    for_each = each.value.rules
    content {
      name                       = security_rule.value.name
      priority                   = security_rule.value.priority
      direction                  = security_rule.value.direction
      access                     = security_rule.value.access
      protocol                   = security_rule.value.protocol
      source_port_range          = security_rule.value.source_port_range
      destination_port_range     = security_rule.value.destination_port_range
      source_address_prefix      = security_rule.value.source_address_prefix
      destination_address_prefix = security_rule.value.destination_address_prefix
    }
  }
}

resource "azurerm_subnet_network_security_group_association" "assoc" {
  for_each                  = var.subnet_nsg_map
  subnet_id                 = "/subscriptions/${data.azurerm_client_config.current.subscription_id}/resourceGroups/${var.resource_group_name}/providers/Microsoft.Network/virtualNetworks/${var.vnet_name}/subnets/${each.key}-subnet"
  network_security_group_id = azurerm_network_security_group.nsg[each.key].id
}

# Gets current Azure subscription ID and subnet ID formatting for use in resource definitions.

data "azurerm_client_config" "current" {}
