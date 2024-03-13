resource "random_string" "affix" {
  length  = 6
  special = false
  upper   = false
  numeric = true
}

resource "azurerm_machine_learning_workspace" "default" {
  name                    = "mlw-${var.workload}"
  location                = var.location
  resource_group_name     = var.resource_group_name
  application_insights_id = var.application_insights_id
  key_vault_id            = var.key_vault_id
  storage_account_id      = var.storage_account_id

  primary_user_assigned_identity = var.user_assigned_identity

  identity {
    type = "UserAssigned"

    identity_ids = [
      var.user_assigned_identity,
    ]
  }

  # encryption {
  #   user_assigned_identity_id = azurerm_user_assigned_identity.mlw.id
  #   key_vault_id              = azurerm_key_vault.example.id
  #   key_id                    = azurerm_key_vault_key.example.id
  # }

  depends_on = [
    azurerm_role_assignment.key_vault,
    azurerm_role_assignment.storage,
    azurerm_role_assignment.storage_contributor,
    azurerm_role_assignment.application_insights
  ]
}

resource "azurerm_role_assignment" "key_vault" {
  scope                = var.key_vault_id
  role_definition_name = "Contributor"
  principal_id         = var.user_assigned_identity
}

resource "azurerm_role_assignment" "storage" {
  scope                = var.storage_account_id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = var.user_assigned_identity
}

resource "azurerm_role_assignment" "storage_contributor" {
  scope                = var.storage_account_id
  role_definition_name = "Contributor"
  principal_id         = var.user_assigned_identity
}

resource "azurerm_role_assignment" "application_insights" {
  scope                = var.application_insights_id
  role_definition_name = "Contributor"
  principal_id         = var.user_assigned_identity
}

### Data Stores ###
resource "azurerm_role_assignment" "lake" {
  scope                = var.data_lake_id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = var.user_assigned_identity
}

resource "azurerm_machine_learning_datastore_datalake_gen2" "lake" {
  name                 = "lake"
  workspace_id         = azurerm_machine_learning_workspace.default.id
  storage_container_id = var.data_lake_id

  depends_on = [azurerm_role_assignment.lake]
}
