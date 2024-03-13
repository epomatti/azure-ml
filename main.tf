terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.95.0"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "2.47.0"
    }
  }
}

resource "random_string" "affix" {
  length  = 6
  special = false
  upper   = false
  numeric = true
}

locals {
  affix = random_string.affix.result
}

resource "azurerm_resource_group" "default" {
  name     = "rg-${var.workload}"
  location = var.location
}

module "monitor" {
  source              = "./modules/monitor"
  workload            = var.workload
  resource_group_name = azurerm_resource_group.default.name
  location            = azurerm_resource_group.default.location
}

module "storage" {
  source              = "./modules/storage"
  workload            = "${var.workload}${local.affix}"
  resource_group_name = azurerm_resource_group.default.name
  location            = azurerm_resource_group.default.location
}

module "keyvault" {
  source              = "./modules/keyvault"
  workload            = "${var.workload}${local.affix}"
  resource_group_name = azurerm_resource_group.default.name
  location            = azurerm_resource_group.default.location
}

module "cr" {
  source              = "./modules/cr"
  workload            = "${var.workload}${local.affix}"
  resource_group_name = azurerm_resource_group.default.name
  location            = azurerm_resource_group.default.location
}

module "data_lake" {
  source                        = "./modules/datalake"
  workload                      = "${var.workload}${local.affix}"
  resource_group_name           = azurerm_resource_group.default.name
  location                      = azurerm_resource_group.default.location
  public_network_access_enabled = var.dsl_public_network_access_enabled
  ip_network_rules              = var.dsl_ip_network_rules
}

module "mssql" {
  source              = "./modules/mssql"
  workload            = var.workload
  resource_group_name = azurerm_resource_group.default.name
  location            = azurerm_resource_group.default.location

  public_network_access_enabled = var.mssql_public_network_access_enabled
  sku                           = var.mssql_sku
  max_size_gb                   = var.mssql_max_size_gb
  admin_login                   = var.mssql_admin_login
  admin_login_password          = var.mssql_admin_login_password
  localfw_start_ip_address      = var.mssql_localfw_start_ip_address
  localfw_end_ip_address        = var.mssql_localfw_end_ip_address
}

module "ml" {
  source              = "./modules/ml"
  workload            = var.workload
  resource_group_name = azurerm_resource_group.default.name
  location            = azurerm_resource_group.default.location

  application_insights_id = module.monitor.application_insights_id
  storage_account_id      = module.storage.storage_account_id
  key_vault_id            = module.keyvault.key_vault_id
  container_registry_id   = module.cr.id

  data_lake_id = module.data_lake.id
}

# module "vnet" {
#   source              = "./modules/vnet"
#   workload            = local.workload
#   resource_group_name = azurerm_resource_group.default.name
#   location            = azurerm_resource_group.default.location
# }




