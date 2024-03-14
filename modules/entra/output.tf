output "app_registration_client_id" {
  value = azuread_application.datastores.client_id
}

output "service_principal_object_id" {
  value = azuread_service_principal.datastores.object_id
}
