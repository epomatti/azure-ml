resource "azurerm_storage_account" "default" {
  name                      = "st${var.workload}"
  location                  = var.location
  resource_group_name       = var.resource_group_name
  account_tier              = "Standard"
  account_replication_type  = "LRS"
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
