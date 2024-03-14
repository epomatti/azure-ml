resource "azurerm_user_assigned_identity" "mlw" {
  name                = "id-mlw"
  location            = var.location
  resource_group_name = var.resource_group_name
}

resource "azurerm_machine_learning_workspace" "default" {
  name                    = "mlw-${var.workload}"
  location                = var.location
  resource_group_name     = var.resource_group_name

  application_insights_id = var.application_insights_id
  key_vault_id            = var.key_vault_id
  storage_account_id      = var.storage_account_id
  container_registry_id   = var.container_registry_id

  public_network_access_enabled  = var.public_network_access_enabled
  primary_user_assigned_identity = azurerm_user_assigned_identity.mlw.id

  identity {
    type = "UserAssigned"

    identity_ids = [
      azurerm_user_assigned_identity.mlw.id
    ]
  }

  managed_network {
    isolation_mode = "AllowOnlyApprovedOutbound"
  }

  depends_on = [
    azurerm_role_assignment.key_vault,
    azurerm_role_assignment.storage,
    azurerm_role_assignment.storage_contributor,
    azurerm_role_assignment.application_insights,
    azurerm_role_assignment.lake,
    azurerm_role_assignment.lake_contributor,
    azurerm_role_assignment.container_registry
  ]
}

resource "azurerm_role_assignment" "key_vault" {
  scope                = var.key_vault_id
  role_definition_name = "Contributor"
  principal_id         = azurerm_user_assigned_identity.mlw.principal_id
}

resource "azurerm_role_assignment" "storage" {
  scope                = var.storage_account_id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = azurerm_user_assigned_identity.mlw.principal_id
}

resource "azurerm_role_assignment" "storage_contributor" {
  scope                = var.storage_account_id
  role_definition_name = "Contributor"
  principal_id         = azurerm_user_assigned_identity.mlw.principal_id
}

resource "azurerm_role_assignment" "application_insights" {
  scope                = var.application_insights_id
  role_definition_name = "Contributor"
  principal_id         = azurerm_user_assigned_identity.mlw.principal_id
}

resource "azurerm_role_assignment" "container_registry" {
  scope                = var.container_registry_id
  role_definition_name = "Contributor"
  principal_id         = azurerm_user_assigned_identity.mlw.principal_id
}

### Data Stores ###
resource "azurerm_role_assignment" "lake" {
  scope                = var.data_lake_id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = azurerm_user_assigned_identity.mlw.principal_id
}

resource "azurerm_role_assignment" "lake_contributor" {
  scope                = var.data_lake_id
  role_definition_name = "Contributor"
  principal_id         = azurerm_user_assigned_identity.mlw.principal_id
}
