data "azuread_client_config" "current" {}

resource "azuread_application" "datastores" {
  display_name = "datastores-${var.workload}"
  owners       = [data.azuread_client_config.current.object_id]
}

resource "azuread_service_principal" "datastores" {
  client_id = azuread_application.datastores.client_id
  owners    = [data.azuread_client_config.current.object_id]
}
