provider "azurerm" {
  features {}
}

module "resource_group" {
  source               = "../../modules/resource_group"
  resource_group       = "${var.project_name}-resources-${var.environment_name}"
  location             = var.location
  project              = var.project_name
}

module "log_analytics" {
  source               = "../../modules/log_analytics"
  location             = var.location
  resource_group       = module.resource_group.resource_group_name
  workspace_name       = "${var.project_name}-logs-${var.environment_name}"
  project              = var.project_name
}

module "postgresql" {
  source                     = "../../modules/postgresql"
  location                   = var.location
  resource_group             = module.resource_group.resource_group_name
  server_name	               = "${var.project_name}-pgss-${var.environment_name}"
  db_username                = var.db_username
  db_password                = var.db_password
  project                    = var.project_name
  log_analytics_workspace_id = module.log_analytics.log_analytics_workspace_id
  depends_on = [module.log_analytics]
}

module "network" {
  source               = "../../modules/network"
  location             = var.location
  resource_group       = module.resource_group.resource_group_name
  address_space        = ["10.0.0.0/16"]
  address_prefixes    = ["10.0.2.0/24"]
  project              = var.project_name
  environment_name     = var.environment_name
}