# Set global values: Resource Group, Location, VNet name and CIDR
resource_group_name = "rg-3tier"
location            = "Southeast Asia"
vnet_name           = "vnet-3tier"
address_space       = ["10.0.0.0/16"]

# Define 3 subnets: web, app, and db
# Each subnet has a name and an address prefix.

subnets = {
  web = {
    name           = "web-subnet"
    address_prefix = "10.0.1.0/24"
  },
  app = {
    name           = "app-subnet"
    address_prefix = "10.0.2.0/24"
  },
  db = {
    name           = "db-subnet"
    address_prefix = "10.0.3.0/24"
  }
}

# Define a mapping of subnets to their respective Network Security Groups (NSGs) and rules.
subnet_nsg_map = {
  web = {
    nsg_name = "web-nsg"
    rules = [
      {
        name                       = "AllowHTTP"
        priority                   = 100
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "80"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
      },
      {
        name                       = "AllowSSH"
        priority                   = 101
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "22"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
      },
      {
        name                       = "AllowOutboundtoAppSubnet"
        priority                   = 102
        direction                  = "Outbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "443"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
      },
      {
        name                       = "DenyAllOutbound"
        priority                   = 4096
        direction                  = "Outbound"
        access                     = "Deny"
        protocol                   = "*"
        source_port_range          = "*"
        destination_port_range     = "*"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
      }
    ]
  },
  app = {
    nsg_name = "app-nsg"
    rules = [{
      name                       = "AllowHTTPS"
      priority                   = 100
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "443"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
      }
      , {
        name                       = "AllowOutboundtoDBSubnet"
        priority                   = 101
        direction                  = "Outbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "1433"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
        }, {
        name                       = "DenyAllOutbound"
        priority                   = 4096
        direction                  = "Outbound"
        access                     = "Deny"
        protocol                   = "*"
        source_port_range          = "*"
        destination_port_range     = "*"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
    }]
  },
  db = {
    nsg_name = "db-nsg"
    rules = [{
      name                       = "AllowSQL"
      priority                   = 100
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "1433"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
      }
      , {
        name                       = "DenyAllOutbound"
        priority                   = 4096
        direction                  = "Outbound"
        access                     = "Deny"
        protocol                   = "*"
        source_port_range          = "*"
        destination_port_range     = "*"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
    }]
  }
}

# Define the configuration for each virtual machine (VM) in the 3-tier architecture.
vm_config = {
  web = {
    name           = "web-vm"
    subnet_id      = "web-subnet"
    vm_size        = "Standard_B1s"
    admin_username = "azureuser"
    admin_password = "P@ssword1234!"
    public_ip      = true
  },
  app = {
    name           = "app-vm"
    subnet_id      = "app-subnet"
    vm_size        = "Standard_B1s"
    admin_username = "azureuser"
    admin_password = "P@ssword1234!"
    public_ip      = false
  },
  db = {
    name           = "db-vm"
    subnet_id      = "db-subnet"
    vm_size        = "Standard_B1s"
    admin_username = "azureuser"
    admin_password = "P@ssword1234!"
    public_ip      = false
  }
}
