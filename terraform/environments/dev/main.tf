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
  source              = "../../modules/network"
  location            = var.location
  resource_group      = module.resource_group.resource_group_name
  address_space       = ["10.1.0.0/16"]
  address_prefixes    = ["10.1.0.0/24"]
  project             = var.project_name
  environment_name    = var.environment_name
}

module "nsg" {
  source              = "../../modules/networksecuritygroup"
  location            = var.location
  resource_group      = module.resource_group.resource_group_name
  vm_subnet_id        = module.network.vm_subnet_id
  project             = var.project_name
  my_public_ip        = var.my_public_ip
  environment_name    = var.environment_name
  depends_on = [
      module.network,
      module.privatelink
      ]
}

module "publicip" {
  source              = "../../modules/publicip"
  location            = var.location
  resource_group      = module.resource_group.resource_group_name
  project             = var.project_name
  environment_name    = var.environment_name
  depends_on = [module.nsg]
}

module "vm" {
  source                = "../../modules/vm"
  location              = var.location
  resource_group        = module.resource_group.resource_group_name
  subnet_id             = module.network.vm_subnet_id
  public_ip_address_id  = module.publicip.public_ip_address_id
  project               = var.project_name
  vm_username           = var.vm_username
  environment_name      = var.environment_name
  depends_on = [module.publicip]
}

module "privatelink" {
  source                    = "../../modules/privatelink"
  location                  = var.location
  resource_group            = module.resource_group.resource_group_name
  subnet_id                 = module.network.vm_subnet_id
  postgresql_id             = module.postgresql.server_id
  private_dns_zone_id       = module.network.private_dns_zone_id
  project                   = var.project_name
  environment_name          = var.environment_name
  depends_on = [
      module.network,
      module.postgresql
      ]
}