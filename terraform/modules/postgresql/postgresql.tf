resource "azurerm_postgresql_server" "main" {
  name                             = var.server_name
  location                         = var.location
  resource_group_name              = var.resource_group

  administrator_login              = var.db_username
  administrator_login_password     = var.db_password

  sku_name                         = "GP_Gen5_2"
  version                          = "11"
  storage_mb                       = 102400

  backup_retention_days            = 7
  geo_redundant_backup_enabled     = true
  auto_grow_enabled                = true

  public_network_access_enabled    = false
  ssl_enforcement_enabled          = true
  ssl_minimal_tls_version_enforced = "TLS1_2"

  tags = {
    project = var.project
  }
}



resource "azurerm_monitor_diagnostic_setting" "diagnostic_settings" {
   name     = "diagnosticSettings"
   log_analytics_workspace_id = var.log_analytics_workspace_id
   target_resource_id = azurerm_postgresql_server.main.id
   
  log { 
    category  = "PostgreSQLLogs"
    enabled   = true 

    retention_policy {
      enabled = false
    }
  }
  
  metric {
    category  = "AllMetrics"

    retention_policy {
      enabled = false
    }
  }

  depends_on  = [
    azurerm_postgresql_server.main
  ]
}

resource "azurerm_postgresql_configuration" "configuration" {
    count = length(var.server_parameters)

    resource_group_name = var.resource_group
    server_name         = azurerm_postgresql_server.main.name
    
    name                = var.server_parameters[count.index].key
    value               = var.server_parameters[count.index].value

    depends_on          = [
      azurerm_postgresql_server.main
    ]
  
}

