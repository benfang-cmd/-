resource "azurerm_resource_group" "example01" {
  name     = "example-resources"
  location = "chinaeast2"
}

resource "azurerm_virtual_network" "example01" {
  name                = "virtnetname"
  address_space       = ["10.0.0.0/16"]
  location            = "${azurerm_resource_group.example01.location}"
  resource_group_name = "${azurerm_resource_group.example01.name}"
}

resource "azurerm_subnet" "example01" {
  name                 = "subnetname"
  resource_group_name  = "${azurerm_resource_group.example01.name}"
  virtual_network_name = "${azurerm_virtual_network.example01.name}"
  address_prefix       = "10.0.2.0/24"
  service_endpoints    = ["Microsoft.Sql", "Microsoft.Storage"]
}

resource "azurerm_storage_account" "example01" {
  name                = "storageaccountname01"
  resource_group_name = "${azurerm_resource_group.example01.name}"

  location                 = "${azurerm_resource_group.example01.location}"
  account_tier             = "Standard"
  account_replication_type = "LRS"

  network_rules {
    default_action             = "Deny"
    ip_rules                   = ["100.0.0.1"]
    virtual_network_subnet_ids = ["${azurerm_subnet.example01.id}"]
  }

  tags = {
    environment = "staging"
  }
}