# Resource Group
resource "azurerm_resource_group" "rg" {
  name     = local.rg_name
  location = var.location
  tags     = local.tags
}

# App Service Plan
resource "azurerm_service_plan" "appserviceplan" {
  name                = local.plan_name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  sku_name            = "F1"
  os_type             = "Windows"
  tags                = local.tags
}

# App Service
resource "azurerm_windows_web_app" "webapp" {
  name                = local.app_name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  service_plan_id = azurerm_service_plan.appserviceplan.id
  
  identity {
    type = "SystemAssigned"
  }

    app_settings = {
      "DbConnectionString" = "@Microsoft.KeyVault(SecretUri=${azurerm_key_vault_secret.keyvault_db_connection_string.id})"
  }

  site_config {
    application_stack {
      dotnet_version = "v8.0"
    }
    always_on = false
  }

  tags = local.tags
}

# Sql Server and Database
resource "azurerm_mssql_server" "sql" {
  name                         = local.sql_name
  resource_group_name          = azurerm_resource_group.rg.name
  location                     = azurerm_resource_group.rg.location
  version                      = "12.0"
  administrator_login          = var.sql_admin_login
  administrator_login_password = var.sql_admin_password
  tags                         = local.tags
}

resource "azurerm_mssql_database" "db" {
  name           = local.db_name
  server_id      = azurerm_mssql_server.sql.id
  sku_name       = "Basic"
  tags           = local.tags
}

# Key Vault
data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "kv" {
  name                        = local.kv_name
  location                    = azurerm_resource_group.rg.location
  resource_group_name         = azurerm_resource_group.rg.name
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  sku_name                    = "standard"
  tags                        = local.tags
}

resource "azurerm_key_vault_secret" "keyvault_db_connection_string" {
  name         = "DbConnectionString"
  value        = "Server=tcp:${azurerm_mssql_server.sql.name}.database.windows.net,1433;Database=${azurerm_mssql_database.db.name};Authentication=Active Directory Managed Identity"
  key_vault_id = azurerm_key_vault.kv.id
}

resource "azurerm_key_vault_access_policy" "peronal_keyvault_policy" {
  key_vault_id = azurerm_key_vault.kv.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = data.azurerm_client_config.current.object_id

  secret_permissions = ["Get", "List", "Set", "Delete"]
  key_permissions    = ["Get", "List", "Create", "Delete"]
}

resource "azurerm_key_vault_access_policy" "webapp_keyvault_policy" {
  key_vault_id = azurerm_key_vault.kv.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id = azurerm_windows_web_app.webapp.identity[0].principal_id

  secret_permissions = ["Get", "List"]
}

# SignalR
resource "azurerm_signalr_service" "signalr" {
  name                = local.signalr_name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  sku {
    name     = "Free_F1"
    capacity = 1
  }

  tags = local.tags
}