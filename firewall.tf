resource "azurerm_resource_group" "example04" {
  name     = "example-resources"
  location = "chinaeast2"
}

resource "azurerm_virtual_network" "example04" {
  name                = "testvnet"
  address_space       = ["10.0.0.0/16"]
  location            = "${azurerm_resource_group.example04.location}"
  resource_group_name = "${azurerm_resource_group.example04.name}"
}

resource "azurerm_subnet" "example04" {
  name                 = "AzureFirewallSubnet"
  resource_group_name  = "${azurerm_resource_group.example04.name}"
  virtual_network_name = "${azurerm_virtual_network.example04.name}"
  address_prefix       = "10.0.1.0/24"
}

resource "azurerm_public_ip" "example04" {
  name                = "testpip"
  location            = "${azurerm_resource_group.example04.location}"
  resource_group_name = "${azurerm_resource_group.example04.name}"
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_firewall" "example04" {
  name                = "testfirewall"
  location            = "${azurerm_resource_group.example04.location}"
  resource_group_name = "${azurerm_resource_group.example04.name}"

  ip_configuration {
    name                 = "configuration"
    subnet_id            = "${azurerm_subnet.example04.id}"
    public_ip_address_id = "${azurerm_public_ip.example04.id}"
  }
}