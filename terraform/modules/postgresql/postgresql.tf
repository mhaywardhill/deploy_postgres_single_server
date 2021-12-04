resource "azurerm_postgresql_server" "main" {
  name                = var.server_name
  location            = var.location
  resource_group_name = var.resource_group

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

resource "time_sleep" "wait_for_postgresql_server" {
  create_duration = "60s"
  depends_on = [
    azurerm_postgresql_server.main
  ]
}

resource "azurerm_monitor_diagnostic_setting" "postgres_diagnostic_setting" {
   name     = "diagnosticSettings"
   log_analytics_workspace_id = var.log_analytics_workspace_id
   target_resource_id = azurerm_postgresql_server.main.id
   
  log { 
    category = "PostgreSQLLogs"
    enabled = true 

    retention_policy {
      enabled = false
    }
  }
  
  metric {
    category = "AllMetrics"

    retention_policy {
      enabled = false
    }
  }

  depends_on          = [
    azurerm_postgresql_server.main,time_sleep.wait_for_postgresql_server
  ]
}