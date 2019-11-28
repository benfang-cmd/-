resource "azurerm_resource_group" "example02" {
  name     = "sql002"
  location = "chinaeast2"
}
resource "azurerm_sql_server" "example02" {
  name                         = "mysqlserver02"
  resource_group_name          = "${azurerm_resource_group.example02.name}"
  location                     = "Chinaeast2"
  version                      = "12.0"
  administrator_login          = "4dm1n157r470r"
  administrator_login_password = "4-v3ry-53cr37-p455w0rd"
}

resource "azurerm_sql_database" "example02" {
  name                = "mysqldatabase02"
  resource_group_name = "${azurerm_resource_group.example02.name}"
  location            = "Chinaeast2"
  server_name         = "${azurerm_sql_server.example02.name}"

  tags = {
    environment = "production"
  }
}