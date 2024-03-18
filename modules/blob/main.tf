data "azuread_client_config" "current" {}

resource "azurerm_storage_account" "blob" {
  name                      = "stblobs${var.workload}"
  resource_group_name       = var.resource_group_name
  location                  = var.location
  account_tier              = "Standard"
  account_replication_type  = "LRS"
  account_kind              = "StorageV2"
  enable_https_traffic_only = true
  min_tls_version           = "TLS1_2"

  # Further controlled by network_rules below
  public_network_access_enabled = true

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

resource "azurerm_role_assignment" "blob" {
  scope                = azurerm_storage_account.blob.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = data.azuread_client_config.current.object_id
}

resource "azurerm_storage_container" "blobs" {
  name                  = "blobs"
  storage_account_name  = azurerm_storage_account.blob.name
  container_access_type = "private"
}

locals {
  file = "contacts.csv"
}

resource "azurerm_storage_blob" "contacts_csv" {
  name                   = local.file
  storage_account_name   = azurerm_storage_account.blob.name
  storage_container_name = azurerm_storage_container.blobs.name
  type                   = "Block"
  source                 = "${path.module}/${local.file}"
}
