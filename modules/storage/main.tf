resource "azurerm_storage_account" "default" {
  name                     = "st${var.workload}"
  location                 = var.location
  resource_group_name      = var.resource_group_name
  account_tier             = "Standard"
  account_replication_type = "LRS"
}
