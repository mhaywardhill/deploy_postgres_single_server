provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "example" {
  name     = "${var.prefix}-resources"
  location = "UK South"
}

resource "azurerm_postgresql_server" "example" {
  name                = "${var.prefix}-postgres"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name

  administrator_login          = var.db_username
  administrator_login_password = var.db_password

  sku_name   = "GP_Gen5_2"
  version    = "11"
  storage_mb = 102400

  backup_retention_days        = 7
  geo_redundant_backup_enabled = true
  auto_grow_enabled            = true

  public_network_access_enabled    = false
  ssl_enforcement_enabled          = true
  ssl_minimal_tls_version_enforced = "TLS1_2"
}

resource "azurerm_postgresql_configuration" "pg_log_line_prefix" {
  name                = "log_line_prefix"
  resource_group_name = azurerm_resource_group.example.name
  server_name         = azurerm_postgresql_server.example.name
  value               = "%m-%p-%l-%u-%d-%a-%h- "
  depends_on          = [
    azurerm_postgresql_server.example
  ]
}