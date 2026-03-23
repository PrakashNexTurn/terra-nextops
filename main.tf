# Create Resource Group
resource "azurerm_resource_group" "app_service_rg" {
  name     = var.resource_group_name
  location = var.location

  tags = var.common_tags
}

# Create App Service Plan
resource "azurerm_service_plan" "app_service_plan" {
  name                = var.app_service_plan_name
  location            = azurerm_resource_group.app_service_rg.location
  resource_group_name = azurerm_resource_group.app_service_rg.name
  os_type             = var.os_type
  sku_name            = var.sku_name

  tags = var.common_tags
}

# Create App Service
resource "azurerm_windows_web_app" "app_service" {
  name                = var.app_service_name
  location            = azurerm_resource_group.app_service_rg.location
  resource_group_name = azurerm_resource_group.app_service_rg.name
  service_plan_id     = azurerm_service_plan.app_service_plan.id

  site_config {
    minimum_tls_version = "1.2"
    scm_type            = "None"
  }

  app_settings = {
    "WEBSITE_RUN_FROM_PACKAGE" = "0"
  }

  https_only = true

  tags = var.common_tags

  depends_on = [azurerm_service_plan.app_service_plan]
}

# Create Application Insights (optional but recommended)
resource "azurerm_application_insights" "app_insights" {
  name                = var.app_insights_name
  location            = azurerm_resource_group.app_service_rg.location
  resource_group_name = azurerm_resource_group.app_service_rg.name
  application_type    = "web"

  tags = var.common_tags
}

# Configure App Service Diagnostics Settings
resource "azurerm_app_service_plan_app_insights_settings" "insights_settings" {
  app_service_plan_id            = azurerm_service_plan.app_service_plan.id
  app_insights_id                = azurerm_application_insights.app_insights.id
  default_sampling_enabled       = true
  default_sampling_percentage    = 100
}

# Optional: Create Custom Domain Binding
resource "azurerm_app_service_custom_hostname_binding" "custom_domain" {
  count               = var.custom_domain != null ? 1 : 0
  hostname            = var.custom_domain
  app_service_id      = azurerm_windows_web_app.app_service.id
  ssl_state           = "SniEnabled"
}