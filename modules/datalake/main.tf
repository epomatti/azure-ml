data "azuread_client_config" "current" {}

resource "azurerm_storage_account" "lake" {
  name                      = "dls${var.workload}"
  resource_group_name       = var.resource_group_name
  location                  = var.location
  account_tier              = "Standard"
  account_replication_type  = "LRS"
  account_kind              = "StorageV2"
  enable_https_traffic_only = true
  min_tls_version           = "TLS1_2"

  # Hierarchical namespace
  is_hns_enabled = true

  # Networking
  public_network_access_enabled = var.public_network_access_enabled

  network_rules {
    default_action             = "Deny"
    ip_rules                   = var.ip_network_rules
    virtual_network_subnet_ids = [var.subnet_id]
    bypass                     = ["AzureServices"]
  }

  lifecycle {
    ignore_changes = [
      network_rules[0].private_link_access
    ]
  }
}

resource "azurerm_role_assignment" "adlsv2" {
  scope                = azurerm_storage_account.lake.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = data.azuread_client_config.current.object_id
}

resource "azurerm_storage_data_lake_gen2_filesystem" "data" {
  name               = "data"
  storage_account_id = azurerm_storage_account.lake.id

  depends_on = [
    azurerm_role_assignment.adlsv2,
  ]
}

locals {
  file = "contacts.csv"
}

resource "azurerm_storage_blob" "csv" {
  name                   = local.file
  storage_account_name   = azurerm_storage_account.lake.name
  storage_container_name = azurerm_storage_data_lake_gen2_filesystem.data.name
  type                   = "Block"
  source                 = "${path.module}/${local.file}"
}

# Adds permission to the Application Registration for the datastores
# resource "azurerm_role_assignment" "app_registration_contributor" {
#   scope                = azurerm_storage_account.lake.id
#   role_definition_name = "Contributor"
#   principal_id         = var.datastores_service_principal_object_id
# }

# resource "azurerm_role_assignment" "app_registration" {
#   scope                = azurerm_storage_account.lake.id
#   role_definition_name = "Storage Blob Data Contributor"
#   principal_id         = var.datastores_service_principal_object_id
# }

# resource "azurerm_role_assignment" "app_registration_owner" {
#   scope                = azurerm_storage_account.lake.id
#   role_definition_name = "Storage Blob Data Owner"
#   principal_id         = var.datastores_service_principal_object_id
# }
