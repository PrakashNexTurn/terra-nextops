output "resource_group_name" {
  description = "Name of the resource group"
  value       = azurerm_resource_group.app_rg.name
}

output "resource_group_id" {
  description = "ID of the resource group"
  value       = azurerm_resource_group.app_rg.id
}

output "app_service_plan_id" {
  description = "ID of the App Service Plan"
  value       = azurerm_service_plan.app_plan.id
}

output "app_service_plan_name" {
  description = "Name of the App Service Plan"
  value       = azurerm_service_plan.app_plan.name
}

output "app_service_id" {
  description = "ID of the App Service"
  value       = var.os_type == "Linux" ? azurerm_linux_web_app.app_service[0].id : null
}

output "app_service_name" {
  description = "Name of the App Service"
  value       = var.os_type == "Linux" ? azurerm_linux_web_app.app_service[0].name : null
}

output "app_service_default_hostname" {
  description = "Default hostname of the App Service"
  value       = var.os_type == "Linux" ? azurerm_linux_web_app.app_service[0].default_hostname : null
}

output "app_service_outbound_ip_addresses" {
  description = "Outbound IP addresses of the App Service"
  value       = var.os_type == "Linux" ? azurerm_linux_web_app.app_service[0].outbound_ip_addresses : null
}
