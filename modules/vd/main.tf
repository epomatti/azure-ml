resource "azurerm_virtual_desktop_workspace" "workspace" {
  name                = "vdws-${var.workload}"
  location            = var.location
  resource_group_name = var.resource_group_name

  friendly_name = "azureml"
  description   = "Private connection to Azure ML"
}

resource "azurerm_virtual_desktop_host_pool" "example" {
  location            = var.location
  resource_group_name = var.resource_group_name

  name                     = "vdpool-${var.workload}"
  friendly_name            = "azuremlpool"
  validate_environment     = true
  start_vm_on_connect      = true
  description              = "Private management of Azure ML"
  type                     = "Personal"
  maximum_sessions_allowed = 1
  load_balancer_type       = "DepthFirst"
}

resource "azurerm_virtual_desktop_host_pool_registration_info" "example" {
  hostpool_id     = azurerm_virtual_desktop_host_pool.example.id
  expiration_date = "2024-03-30T23:40:52Z"
}
