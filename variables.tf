variable "location" {
  type    = string
  default = "eastus2"
}

variable "workload" {
  type    = string
  default = "litware"
}

variable "allowed_ip_address" {
  type = string
}

### AML ###
variable "mlw_public_network_access_enabled" {
  type = bool
}

variable "mlw_create_private_endpoint_flag" {
  type = bool
}

variable "mlw_instance_node_public_ip_enabled" {
  type = bool
}

variable "mlw_instance_create_flag" {
  type = bool
}

variable "mlw_instance_vm_size" {
  type = string
}

variable "mlw_instance_ssh_public_key_rel_path" {
  type = string
}

### MSSQL ###
variable "mssql_create_flag" {
  type = bool
}

variable "mssql_sku" {
  type = string
}

variable "mssql_max_size_gb" {
  type = number
}

variable "mssql_admin_login" {
  type = string
}

variable "mssql_admin_login_password" {
  type = string
}

### Virtual Machine ###
variable "vm_create_flag" {
  type = bool
}

variable "vm_size" {
  type = string
}
