variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "workload" {
  type = string
}

variable "ip_network_rules" {
  type = list(string)
}

variable "datastores_service_principal_object_id" {
  type = string
}

variable "subnet_id" {
  type = string
}
