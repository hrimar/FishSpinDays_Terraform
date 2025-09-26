output "webapp_url" {
  value = azurerm_windows_web_app.webapp.default_hostname
}

output "sql_server_name" {
  value = azurerm_mssql_server.sql.name
}

output "key_vault_uri" {
  value = azurerm_key_vault.kv.vault_uri
}