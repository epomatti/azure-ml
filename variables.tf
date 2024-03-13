variable "location" {
  type    = string
  default = "eastus2"
}

variable "workload" {
  type    = string
  default = "litware"
}

### MSSQL ###
variable "mssql_public_network_access_enabled" {
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

variable "mssql_localfw_start_ip_address" {
  type = string
}

variable "mssql_localfw_end_ip_address" {
  type = string
}
