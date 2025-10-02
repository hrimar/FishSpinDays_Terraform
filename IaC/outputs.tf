output "resource_group_name" {
  value       = azurerm_resource_group.rg.name
  description = "Resource group name"
}

output "webapp_url" {
  value = azurerm_windows_web_app.webapp.default_hostname
}

output "sql_server_name" {
  value = azurerm_mssql_server.sql.name
}

output "sql_server_fqdn" {
  value       = azurerm_mssql_server.sql.fully_qualified_domain_name
  description = "SQL Server FQDN"
}

output "sql_db_name" {
  value       = azurerm_mssql_database.db.name
  description = "Database name"
}

output "key_vault_uri" {
  value = azurerm_key_vault.kv.vault_uri
}