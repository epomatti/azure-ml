resource "azurerm_user_assigned_identity" "mlw" {
  name                = "id-mlw-${var.workload}"
  location            = var.location
  resource_group_name = var.resource_group_name
}

resource "random_string" "affix" {
  length  = 6
  special = false
  upper   = false
  numeric = true
}

resource "azurerm_machine_learning_workspace" "example" {
  name                    = "mlw-${var.workload}${local.random_string.result}"
  location                = var.location
  resource_group_name     = var.resource_group_name
  application_insights_id = var.application_insights_id
  key_vault_id            = var.key_vault_id
  storage_account_id      = var.storage_account_id

  identity {
    type = "UserAssigned"

    identity_ids = [
      azurerm_user_assigned_identity.mlw.id,
    ]
  }

  # encryption {
  #   key_vault_id = azurerm_key_vault.example.id
  #   key_id       = azurerm_key_vault_key.example.id
  # }

  depends_on = [
    azurerm_role_assignment.key_vault,
    azurerm_role_assignment.storage,
    azurerm_role_assignment.application_insights
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

resource "azurerm_role_assignment" "application_insights" {
  scope                = var.application_insights_id
  role_definition_name = "Contributor"
  principal_id         = azurerm_user_assigned_identity.mlw.principal_id
}
