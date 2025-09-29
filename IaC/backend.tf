terraform {
  backend "azurerm" {
    resource_group_name  = "fishspindays-tfstate-prod-ne-rg"
    storage_account_name = "fishspindaysprodtfstate"
    container_name       = "tfstate"
    key                  = "fishspindays-prod-ne.tfstate"
  }
}