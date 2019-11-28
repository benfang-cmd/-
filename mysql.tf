#config the Azure provider
# provider "azurerm1" {
#   subscription_id = "21175d26-2025-4919-b875-44afdbea187e"
#   environment     = "china"
# }

resource "azurerm_resource_group" "example" {
  name     = "api-rg-pro"
  location = "chinaeast2"
}

resource "azurerm_mysql_server" "example" {
  name                = "mysql-server-9"
  location            = "${azurerm_resource_group.example.location}"
  resource_group_name = "${azurerm_resource_group.example.name}"

  sku {
    name     = "B_Gen5_2"
    capacity = 2
    tier     = "Basic"
    family   = "Gen5"
  }

  storage_profile {
    storage_mb            = 5120
    backup_retention_days = 7
    geo_redundant_backup  = "Disabled"
  }

  administrator_login          = "psqladminun"
  administrator_login_password = "H@Sh1CoR3!"
  version                      = "5.7"
  ssl_enforcement              = "Enabled"
}

resource "azurerm_mysql_configuration" "example" {
  name                = "interactive_timeout"
  resource_group_name = "${azurerm_resource_group.example.name}"
  server_name         = "${azurerm_mysql_server.example.name}"
  value               = "600"
}