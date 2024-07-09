resource "azurerm_container_registry" "default" {
  name                          = "cr${var.workload}"
  resource_group_name           = var.resource_group_name
  location                      = var.location
  admin_enabled                 = false
  public_network_access_enabled = true

  # Premium required for AML outbound access via private endpoints
  sku = "Premium"

  network_rule_set {
    default_action = "Deny"

    ip_rule {
      action   = "Allow"
      ip_range = "${var.allowed_ip_address}/32"
    }
  }

  network_rule_bypass_option = "AzureServices"
}

# Customer-managed VNET and private endpoint
resource "azurerm_private_dns_zone" "registry" {
  name                = "privatelink.azurecr.io"
  resource_group_name = var.resource_group_name
}

resource "azurerm_private_dns_zone_virtual_network_link" "registry" {
  name                  = "registry-link"
  resource_group_name   = var.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.registry.name
  virtual_network_id    = var.vnet_id
  registration_enabled  = false
}

# Account Endpoint
resource "azurerm_private_endpoint" "registry" {
  name                = "pe-cr"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.allowed_subnet_id

  private_dns_zone_group {
    name = azurerm_private_dns_zone.registry.name
    private_dns_zone_ids = [
      azurerm_private_dns_zone.registry.id
    ]
  }

  private_service_connection {
    name                           = "registry"
    private_connection_resource_id = azurerm_container_registry.default.id
    is_manual_connection           = false
    subresource_names              = ["registry"]
  }
}
