variable "location" {
  type        = string
  default     = "northeurope"
  description = "Azure region for resources."
}

variable "sql_admin_login" {
  type        = string
  default     = "sqladmin"
  description = "SQL Server admin username."
}

variable "sql_admin_password" {
  type        = string
  description = "SQL Server admin password."
  sensitive   = true
}

variable "my_ip_address" {
  type        = string
  description = "Your public IP address to allow access to SQL Server."
}

variable "terraform_sp_object_id" {
  type        = string
  description = "Object ID of the Service Principal used by CI"
}