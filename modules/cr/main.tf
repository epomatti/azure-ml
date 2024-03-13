resource "azurerm_container_registry" "default" {
  name                = "cr${var.workload}"
  resource_group_name = var.resource_group_name
  location            = var.location
  admin_enabled       = false

  # Premium required for AML outbound access via private endpoints
  sku = "Premium"
}
