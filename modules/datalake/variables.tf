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

variable "ip_network_rules" {
  type = list(string)
}

variable "datastores_app_registration_client_id" {
  type = string
}
