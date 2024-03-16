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

variable "sku" {
  type = string
}

variable "max_size_gb" {
  type = number
}

variable "admin_login" {
  type = string
}

variable "admin_login_password" {
  type      = string
  sensitive = true
}

variable "localfw_start_ip_address" {
  type = string
}

variable "localfw_end_ip_address" {
  type = string
}

variable "subnet_id" {
  type = string
}
