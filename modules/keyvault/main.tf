data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "default" {
  name                       = "kv-${var.workload}"
  location                   = var.location
  resource_group_name        = var.resource_group_name
  tenant_id                  = data.azurerm_client_config.current.tenant_id
  sku_name                   = "standard"
  purge_protection_enabled   = false
  soft_delete_retention_days = 7
  enable_rbac_authorization  = true

  # Further controlled by network_acls below
  public_network_access_enabled = true

  network_acls {
    default_action             = "Deny"
    virtual_network_subnet_ids = [var.subnet_id]
    bypass                     = "AzureServices"
    ip_rules                   = var.allowed_ip_addresses
  }
}

resource "azurerm_role_assignment" "current" {
  scope                = azurerm_key_vault.default.id
  role_definition_name = "Key Vault Administrator"
  principal_id         = data.azurerm_client_config.current.object_id
}
