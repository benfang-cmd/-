resource "azurerm_resource_group" "example03" {
  name     = "example-resources"
  location = "Chinaeast2"
}

resource "azurerm_virtual_network" "example03" {
  name                = "example-network"
  resource_group_name = "${azurerm_resource_group.example03.name}"
  location            = "${azurerm_resource_group.example03.location}"
  address_space       = ["10.254.0.0/16"]
}

resource "azurerm_subnet" "frontend" {
  name                 = "frontend"
  resource_group_name  = "${azurerm_resource_group.example03.name}"
  virtual_network_name = "${azurerm_virtual_network.example03.name}"
  address_prefix       = "10.254.0.0/24"
}

resource "azurerm_subnet" "backend" {
  name                 = "backend"
  resource_group_name  = "${azurerm_resource_group.example03.name}"
  virtual_network_name = "${azurerm_virtual_network.example03.name}"
  address_prefix       = "10.254.2.0/24"
}

resource "azurerm_public_ip" "example" {
  name                = "example-pip"
  resource_group_name = "${azurerm_resource_group.example03.name}"
  location            = "${azurerm_resource_group.example03.location}"
  allocation_method   = "Dynamic"
}

# since these variables are re-used - a locals block makes this more maintainable
locals {
  backend_address_pool_name      = "${azurerm_virtual_network.example03.name}-beap"
  frontend_port_name             = "${azurerm_virtual_network.example03.name}-feport"
  frontend_ip_configuration_name = "${azurerm_virtual_network.example03.name}-feip"
  http_setting_name              = "${azurerm_virtual_network.example03.name}-be-htst"
  listener_name                  = "${azurerm_virtual_network.example03.name}-httplstn"
  request_routing_rule_name      = "${azurerm_virtual_network.example03.name}-rqrt"
  redirect_configuration_name    = "${azurerm_virtual_network.example03.name}-rdrcfg"
}

resource "azurerm_application_gateway" "network" {
  name                = "example-appgateway"
  resource_group_name = "${azurerm_resource_group.example03.name}"
  location            = "${azurerm_resource_group.example03.location}"

  sku {
    name     = "Standard_Small"
    tier     = "Standard"
    capacity = 2
  }

  gateway_ip_configuration {
    name      = "my-gateway-ip-configuration"
    subnet_id = "${azurerm_subnet.frontend.id}"
  }

  frontend_port {
    name = "${local.frontend_port_name}"
    port = 80
  }

  frontend_ip_configuration {
    name                 = "${local.frontend_ip_configuration_name}"
    public_ip_address_id = "${azurerm_public_ip.example.id}"
  }

  backend_address_pool {
    name = "${local.backend_address_pool_name}"
  }

  backend_http_settings {
    name                  = "${local.http_setting_name}"
    cookie_based_affinity = "Disabled"
    path                  = "/path1/"
    port                  = 80
    protocol              = "Http"
    request_timeout       = 1
  }

  http_listener {
    name                           = "${local.listener_name}"
    frontend_ip_configuration_name = "${local.frontend_ip_configuration_name}"
    frontend_port_name             = "${local.frontend_port_name}"
    protocol                       = "Http"
  }

  request_routing_rule {
    name                       = "${local.request_routing_rule_name}"
    rule_type                  = "Basic"
    http_listener_name         = "${local.listener_name}"
    backend_address_pool_name  = "${local.backend_address_pool_name}"
    backend_http_settings_name = "${local.http_setting_name}"
  }
}