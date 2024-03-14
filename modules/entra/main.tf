resource "azuread_application" "datastores" {
  display_name = "datastores-${var.workload}"
}

resource "azuread_service_principal" "datastores" {
  client_id = azuread_application.datastores.client_id
}
