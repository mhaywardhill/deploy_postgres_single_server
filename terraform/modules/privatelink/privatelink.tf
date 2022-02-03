resource "azurerm_private_endpoint" "main" {
  name                  = "endpoint-${var.project}-${var.environment_name}"
  location              = var.location
  resource_group_name   = var.resource_group
  subnet_id             = var.subnet_id

  private_service_connection {
    name                           = "privateserviceconnection-${var.project}-${var.environment_name}"
    private_connection_resource_id = var.postgresql_id
    subresource_names              = ["postgresqlServer"]
    is_manual_connection              = false
  }

  private_dns_zone_group {
    name                  = "dnsgroup-${var.project}-${var.environment_name}"
    private_dns_zone_ids = [var.private_dns_zone_id]
  }

  tags = {
    project = var.project
  }
}