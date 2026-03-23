# AKS Cluster Outputs
output "aks_cluster_id" {
  description = "AKS Cluster resource ID"
  value       = azurerm_kubernetes_cluster.aks.id
}

output "aks_cluster_name" {
  description = "AKS Cluster name"
  value       = azurerm_kubernetes_cluster.aks.name
}

output "aks_cluster_fqdn" {
  description = "AKS Cluster FQDN"
  value       = azurerm_kubernetes_cluster.aks.fqdn
}

output "aks_kube_config" {
  description = "Kube config for AKS cluster"
  value       = azurerm_kubernetes_cluster.aks.kube_config
  sensitive   = true
}

output "aks_kube_config_raw" {
  description = "Raw Kube config for AKS cluster"
  value       = azurerm_kubernetes_cluster.aks.kube_config_raw
  sensitive   = true
}

output "aks_cluster_username" {
  description = "Username for local administrator account"
  value       = azurerm_kubernetes_cluster.aks.linux_profile[0].admin_username
}

output "aks_identity_object_id" {
  description = "Object ID of the managed identity"
  value       = azurerm_kubernetes_cluster.aks.identity[0].principal_id
}

output "aks_kubelet_identity_object_id" {
  description = "Object ID of the kubelet managed identity"
  value       = azurerm_kubernetes_cluster.aks.kubelet_identity[0].object_id
}

# Azure Container Registry Outputs
output "acr_id" {
  description = "Azure Container Registry resource ID"
  value       = var.enable_acr ? azurerm_container_registry.aks[0].id : null
}

output "acr_login_server" {
  description = "Azure Container Registry login server URL"
  value       = var.enable_acr ? azurerm_container_registry.aks[0].login_server : null
}

output "acr_name" {
  description = "Azure Container Registry name"
  value       = var.enable_acr ? azurerm_container_registry.aks[0].name : null
}

output "acr_registry_url" {
  description = "Azure Container Registry registry URL"
  value       = var.enable_acr ? "https://${azurerm_container_registry.aks[0].login_server}" : null
}

output "acr_admin_username" {
  description = "ACR admin username (if admin enabled)"
  value       = var.enable_acr && var.acr_admin_enabled ? azurerm_container_registry.aks[0].admin_username : null
}

output "acr_admin_password" {
  description = "ACR admin password (if admin enabled)"
  value       = var.enable_acr && var.acr_admin_enabled ? azurerm_container_registry.aks[0].admin_password : null
  sensitive   = true
}

# Resource Group Outputs
output "resource_group_id" {
  description = "Resource Group resource ID"
  value       = azurerm_resource_group.aks.id
}

output "resource_group_name" {
  description = "Resource Group name"
  value       = azurerm_resource_group.aks.name
}

output "resource_group_location" {
  description = "Resource Group location"
  value       = azurerm_resource_group.aks.location
}

# Virtual Network Outputs
output "vnet_id" {
  description = "Virtual Network resource ID"
  value       = azurerm_virtual_network.aks.id
}

output "vnet_name" {
  description = "Virtual Network name"
  value       = azurerm_virtual_network.aks.name
}

output "subnet_id" {
  description = "AKS Subnet resource ID"
  value       = azurerm_subnet.aks.id
}

output "subnet_name" {
  description = "AKS Subnet name"
  value       = azurerm_subnet.aks.name
}

# Kubeconfig generation instruction
output "kubeconfig_command" {
  description = "Command to get kubeconfig"
  value       = "az aks get-credentials --resource-group ${azurerm_resource_group.aks.name} --name ${azurerm_kubernetes_cluster.aks.name}"
}