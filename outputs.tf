output "app_service_plan_id" {
  description = "ID of the App Service Plan"
  value       = azurerm_service_plan.app_service_plan.id
}

output "app_service_id" {
  description = "ID of the App Service"
  value       = azurerm_windows_web_app.app_service.id
}

output "app_service_default_hostname" {
  description = "Default hostname of the App Service"
  value       = azurerm_windows_web_app.app_service.default_hostname
}

output "app_service_identity" {
  description = "Identity block of the App Service"
  value       = azurerm_windows_web_app.app_service.identity
}

output "app_insights_id" {
  description = "ID of the Application Insights"
  value       = azurerm_application_insights.app_insights.id
}

output "app_insights_instrumentation_key" {
  description = "Instrumentation key of Application Insights"
  value       = azurerm_application_insights.app_insights.instrumentation_key
  sensitive   = true
}

output "resource_group_name" {
  description = "Name of the resource group"
  value       = azurerm_resource_group.app_service_rg.name
}

output "resource_group_id" {
  description = "ID of the resource group"
  value       = azurerm_resource_group.app_service_rg.id
}