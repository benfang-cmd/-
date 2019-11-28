#config the Azure provider
provider "azurerm" {
  subscription_id = "21175d26-2025-4919-b875-44afdbea187e"
  environment     = "china"
}

#创建资源组
resource "azurerm_resource_group" "test001" {
  name     = "LoadBalancerRG02"
  location = "chinaeast2"
}
#创建公共IP
resource "azurerm_public_ip" "test001" {
  name                = "PublicIPForLB"
  location            = "chinaeast2"
  resource_group_name = azurerm_resource_group.test001.name
  allocation_method   = "Static"
}
#创建负载均衡
resource "azurerm_lb" "test001" {
  name                = "TestLoadBalancer"
  location            = "chinaeast2"
  resource_group_name = azurerm_resource_group.test001.name

  frontend_ip_configuration {
    name                 = "PublicIPAddress"
    public_ip_address_id = azurerm_public_ip.test001.id
  }
}

