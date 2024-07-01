variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "workload" {
  type = string
}

variable "public_network_access_enabled" {
  type = bool
}

variable "application_insights_id" {
  type = string
}

variable "key_vault_id" {
  type = string
}

variable "storage_account_id" {
  type = string
}

variable "container_registry_id" {
  type = string
}

variable "data_lake_id" {
  type = string
}

variable "blobs_id" {
  type = string
}

variable "managed_network_isolation_mode" {
  type = string
}
