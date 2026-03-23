# Create Resource Group
resource "azurerm_resource_group" "app_rg" {
  name     = var.resource_group_name
  location = var.location
  tags     = var.tags
}

# Create App Service Plan
resource "azurerm_service_plan" "app_plan" {
  name                = var.app_service_plan_name
  location            = azurerm_resource_group.app_rg.location
  resource_group_name = azurerm_resource_group.app_rg.name
  os_type             = var.os_type
  sku_name            = var.app_service_sku
  tags                = var.tags
}

# Create App Service
resource "azurerm_linux_web_app" "app_service" {
  count = var.os_type == "Linux" ? 1 : 0

  name                = var.app_service_name
  location            = azurerm_resource_group.app_rg.location
  resource_group_name = azurerm_resource_group.app_rg.name
  service_plan_id     = azurerm_service_plan.app_plan.id
  tags                = var.tags

  site_config {
    application_stack {
      python_version = "3.9"
    }
    minimum_tls_version = "1.2"
  }

  app_settings = {
    "WEBSITE_RUN_FROM_PACKAGE" = "0"
  }

  https_only = true

  depends_on = [
    azurerm_service_plan.app_plan
  ]
}

# Alternative: Create Windows Web App (uncomment if needed)
# resource "azurerm_windows_web_app" "app_service" {
#   count = var.os_type == "Windows" ? 1 : 0
#
#   name                = var.app_service_name
#   location            = azurerm_resource_group.app_rg.location
#   resource_group_name = azurerm_resource_group.app_rg.name
#   service_plan_id     = azurerm_service_plan.app_plan.id
#   tags                = var.tags
#
#   site_config {
#     minimum_tls_version = "1.2"
#   }
#
#   https_only = true
#
#   depends_on = [
#     azurerm_service_plan.app_plan
#   ]
# }
