output "aml_workspace_id" {
  value = azurerm_machine_learning_workspace.default.id
}

output "aml_workspace_name" {
  value = azurerm_machine_learning_workspace.default.name
}

output "aml_identity_principal_id" {
  value = azurerm_user_assigned_identity.mlw.principal_id
}
