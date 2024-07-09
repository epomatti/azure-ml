resource "azurerm_private_dns_zone" "aml" {
  name                = "privatelink.api.azureml.ms"
  resource_group_name = var.resource_group_name
}

resource "azurerm_private_dns_zone_virtual_network_link" "aml" {
  name                  = "aml-workspace-link"
  resource_group_name   = var.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.aml.name
  virtual_network_id    = var.vnet_id
  registration_enabled  = false
}

# Account Endpoint
resource "azurerm_private_endpoint" "aml" {
  name                = "pe-aml"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.subnet_id

  private_dns_zone_group {
    name = azurerm_private_dns_zone.aml.name
    private_dns_zone_ids = [
      azurerm_private_dns_zone.aml.id
    ]
  }

  private_service_connection {
    name                           = "aml-workspace"
    private_connection_resource_id = var.aml_workspace_id
    is_manual_connection           = false
    subresource_names              = ["amlworkspace"]
  }
}
