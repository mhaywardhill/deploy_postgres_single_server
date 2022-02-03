resource "azurerm_virtual_network" "main" {
  name                 = "vnet-${var.project}-${var.environment_name}"
  address_space        = var.address_space
  location             = var.location
  resource_group_name  = var.resource_group

  tags = {
    project = var.project
  }
}

resource "azurerm_subnet" "vm" {
  name                 = "snet-${var.project}-vm-${var.environment_name}"
  resource_group_name  = var.resource_group
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = var.address_prefixes
  
  enforce_private_link_endpoint_network_policies = true
}

resource "azurerm_private_dns_zone" "main" {
  name                = "privatelink.postgres.database.azure.com"
  resource_group_name = var.resource_group
  
  tags = {
    project = var.project
  }
}

resource "azurerm_private_dns_zone_virtual_network_link" "main" {
  name                  = "${var.project}_dns_zone_link-${var.environment_name}"
  private_dns_zone_name = azurerm_private_dns_zone.main.name
  virtual_network_id    = azurerm_virtual_network.main.id
  resource_group_name   = var.resource_group
  
  tags = {
    project = var.project
  }
}