# Azure Kubernetes Service (AKS) Cluster Configuration

# Create Azure Resource Group
resource "azurerm_resource_group" "aks" {
  name     = var.aks_resource_group_name
  location = var.azure_region

  tags = merge(
    var.tags,
    {
      Name        = var.aks_resource_group_name
      Environment = var.environment
      ManagedBy   = "Terraform"
    }
  )
}

# Create Virtual Network for AKS
resource "azurerm_virtual_network" "aks" {
  name                = var.aks_vnet_name
  address_space       = var.aks_vnet_address_space
  location            = azurerm_resource_group.aks.location
  resource_group_name = azurerm_resource_group.aks.name

  tags = merge(
    var.tags,
    {
      Name = var.aks_vnet_name
    }
  )
}

# Create Subnet for AKS
resource "azurerm_subnet" "aks" {
  name                 = var.aks_subnet_name
  resource_group_name  = azurerm_resource_group.aks.name
  virtual_network_name = azurerm_virtual_network.aks.name
  address_prefixes     = var.aks_subnet_address_prefixes

  depends_on = [azurerm_virtual_network.aks]
}

# Create Azure Container Registry (ACR)
resource "azurerm_container_registry" "aks" {
  count               = var.enable_acr ? 1 : 0
  name                = var.acr_name
  resource_group_name = azurerm_resource_group.aks.name
  location            = azurerm_resource_group.aks.location
  sku                 = var.acr_sku
  admin_enabled       = var.acr_admin_enabled

  tags = merge(
    var.tags,
    {
      Name = var.acr_name
    }
  )
}

# Create AKS Cluster
resource "azurerm_kubernetes_cluster" "aks" {
  name                = var.aks_cluster_name
  location            = azurerm_resource_group.aks.location
  resource_group_name = azurerm_resource_group.aks.name
  dns_prefix          = var.aks_dns_prefix
  kubernetes_version  = var.kubernetes_version

  # Default Node Pool Configuration
  default_node_pool {
    name           = var.aks_node_pool_name
    node_count     = var.aks_node_count
    vm_size        = var.aks_node_vm_size
    os_disk_size_gb = var.aks_node_os_disk_size

    vnet_subnet_id = azurerm_subnet.aks.id

    enable_auto_scaling = var.enable_auto_scaling
    min_count          = var.min_node_count
    max_count          = var.max_node_count

    tags = merge(
      var.tags,
      {
        Name = var.aks_node_pool_name
      }
    )
  }

  # Identity Configuration
  identity {
    type = "SystemAssigned"
  }

  # Network Configuration
  network_profile {
    network_plugin     = var.aks_network_plugin
    network_policy     = var.aks_network_policy
    service_cidr       = var.aks_service_cidr
    dns_service_ip     = var.aks_dns_service_ip
    docker_bridge_cidr = var.aks_docker_bridge_cidr
    load_balancer_sku  = var.aks_load_balancer_sku
  }

  # API Server Authorized IP Ranges (optional)
  api_server_authorized_ip_ranges = var.api_server_authorized_ip_ranges

  # Enable RBAC
  role_based_access_control_enabled = var.enable_rbac

  # Azure AD Integration (optional)
  dynamic "azure_active_directory_role_based_access_control" {
    for_each = var.enable_azure_ad_rbac ? [1] : []
    content {
      managed                = true
      azure_rbac_enabled     = true
      admin_group_object_ids = var.azure_ad_admin_group_object_ids
    }
  }

  # OMS Agent (Monitoring)
  dynamic "oms_agent" {
    for_each = var.enable_monitoring ? [1] : []
    content {
      log_analytics_workspace_id = var.log_analytics_workspace_id
    }
  }

  # HTTP Application Routing (optional)
  http_application_routing_enabled = var.enable_http_app_routing

  # Enable Pod Security Policy (if supported)
  pod_security_policy_enabled = var.enable_pod_security_policy

  tags = merge(
    var.tags,
    {
      Name        = var.aks_cluster_name
      Environment = var.environment
      ManagedBy   = "Terraform"
    }
  )

  depends_on = [
    azurerm_subnet.aks
  ]
}

# Integrate AKS with ACR (if ACR is enabled)
resource "azurerm_role_assignment" "aks_to_acr" {
  count              = var.enable_acr ? 1 : 0
  scope              = azurerm_container_registry.aks[0].id
  role_definition_name = "AcrPull"
  principal_id       = azurerm_kubernetes_cluster.aks.kubelet_identity[0].object_id
}

# Create additional Node Pool (optional)
resource "azurerm_kubernetes_cluster_node_pool" "additional" {
  count                 = var.create_additional_node_pool ? 1 : 0
  name                  = var.additional_node_pool_name
  kubernetes_cluster_id = azurerm_kubernetes_cluster.aks.id
  node_count            = var.additional_node_count
  vm_size               = var.additional_node_vm_size

  vnet_subnet_id = azurerm_subnet.aks.id

  enable_auto_scaling = var.enable_additional_node_auto_scaling
  min_count          = var.additional_min_node_count
  max_count          = var.additional_max_node_count

  tags = merge(
    var.tags,
    {
      Name = var.additional_node_pool_name
    }
  )
}
