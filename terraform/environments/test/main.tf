provider "azurerm" {
  features {}
}

module "resource_group" {
  source               = "../../modules/resource_group"
  resource_group       = "${var.project_name}-resources-${var.environment_name}"
  location             = var.location
}

module "log_analytics" {
  source               = "../../modules/log_analytics"
  location             = var.location
  resource_group       = module.resource_group.resource_group_name
  workspace_name       = "${var.project_name}-logs-${var.environment_name}"
}

module "postgresql" {
  source               = "../../modules/postgresql"
  location             = var.location
  resource_group       = module.resource_group.resource_group_name
  server_name	       = "${var.project_name}-pgss-${var.environment_name}"
  db_username	       = var.db_username
  db_password          = var.db_password
  log_analytics_workspace_id = module.log_analytics.log_analytics_workspace_id
}