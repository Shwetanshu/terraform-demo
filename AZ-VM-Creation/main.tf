resource "azurerm_resource_group" "resource_gp" {
  name = "Demo-RG"
  location = "eastus"
}

resource "azurerm_virtual_network" "main" {
  name                = "demo-network"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.resource_gp.location
  resource_group_name = azurerm_resource_group.resource_gp.name
}

resource "azurerm_subnet" "internal" {
  name                 = "demo-internal"
  resource_group_name  = azurerm_resource_group.resource_gp.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefix       = "10.0.2.0/24"
}

resource "azurerm_public_ip" "ip_alloc" {
  name                = "acceptanceTestPublicIp1"
  location            = azurerm_resource_group.resource_gp.location
  resource_group_name = azurerm_resource_group.resource_gp.name
  allocation_method   = "Static"

    tags = {
    environment = "dev"
  }
}

resource "azurerm_network_interface" "main" {
  name                = "demo-nic"
  location            = azurerm_resource_group.resource_gp.location
  resource_group_name = azurerm_resource_group.resource_gp.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.internal.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.ip_alloc.id
  }
}

resource "azurerm_linux_virtual_machine" "main" {
  name                = "demo-machine"
  resource_group_name = azurerm_resource_group.resource_gp.name
  location            = azurerm_resource_group.resource_gp.location
  size                = "Standard_DS1_v2"
  admin_username      = "adminuser"
  network_interface_ids = [
    azurerm_network_interface.main.id,
  ]

  admin_ssh_key {
    username   = "adminuser"
    public_key = file("~/.ssh/id_rsa.pub")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }

    tags = {
    environment = "dev"
  }

}

output "public_ip_address" {
  value = azurerm_public_ip.ip_alloc.ip_address
}