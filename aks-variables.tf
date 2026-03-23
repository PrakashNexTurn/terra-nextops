# Azure Configuration Variables
variable "azure_subscription_id" {
  description = "Azure Subscription ID"
  type        = string
  sensitive   = true
}

variable "azure_client_id" {
  description = "Azure Client ID (Service Principal)"
  type        = string
  sensitive   = true
}

variable "azure_client_secret" {
  description = "Azure Client Secret (Service Principal)"
  type        = string
  sensitive   = true
}

variable "azure_tenant_id" {
  description = "Azure Tenant ID"
  type        = string
  sensitive   = true
}

variable "azure_region" {
  description = "Azure region where resources will be created"
  type        = string
  default     = "East US"
}

# AKS Resource Group Variables
variable "aks_resource_group_name" {
  description = "Name of the AKS resource group"
  type        = string
  default     = "rg-aks-cluster"
}

# AKS Virtual Network Variables
variable "aks_vnet_name" {
  description = "Name of the virtual network"
  type        = string
  default     = "vnet-aks"
}

variable "aks_vnet_address_space" {
  description = "Address space for the virtual network"
  type        = list(string)
  default     = ["10.0.0.0/16"]
}

variable "aks_subnet_name" {
  description = "Name of the AKS subnet"
  type        = string
  default     = "subnet-aks"
}

variable "aks_subnet_address_prefixes" {
  description = "Address prefixes for the AKS subnet"
  type        = list(string)
  default     = ["10.0.1.0/24"]
}

# AKS Cluster Variables
variable "aks_cluster_name" {
  description = "Name of the AKS cluster"
  type        = string
  default     = "aks-cluster"
}

variable "aks_dns_prefix" {
  description = "DNS prefix for the AKS cluster"
  type        = string
  default     = "aks"
}

variable "kubernetes_version" {
  description = "Kubernetes version to use for the AKS cluster"
  type        = string
  default     = "1.28"
}

# AKS Node Pool Variables
variable "aks_node_pool_name" {
  description = "Name of the default node pool"
  type        = string
  default     = "nodepool1"
}

variable "aks_node_count" {
  description = "Initial number of nodes in the default node pool"
  type        = number
  default     = 3
}

variable "aks_node_vm_size" {
  description = "VM size for AKS nodes"
  type        = string
  default     = "Standard_D2s_v3"
}

variable "aks_node_os_disk_size" {
  description = "OS disk size in GB for AKS nodes"
  type        = number
  default     = 30
}

variable "enable_auto_scaling" {
  description = "Enable autoscaling for the default node pool"
  type        = bool
  default     = true
}

variable "min_node_count" {
  description = "Minimum number of nodes for autoscaling"
  type        = number
  default     = 1
}

variable "max_node_count" {
  description = "Maximum number of nodes for autoscaling"
  type        = number
  default     = 5
}

# Additional Node Pool Variables
variable "create_additional_node_pool" {
  description = "Create an additional node pool"
  type        = bool
  default     = false
}

variable "additional_node_pool_name" {
  description = "Name of the additional node pool"
  type        = string
  default     = "nodepool2"
}

variable "additional_node_count" {
  description = "Initial number of nodes in the additional pool"
  type        = number
  default     = 2
}

variable "additional_node_vm_size" {
  description = "VM size for additional node pool"
  type        = string
  default     = "Standard_D2s_v3"
}

variable "enable_additional_node_auto_scaling" {
  description = "Enable autoscaling for additional node pool"
  type        = bool
  default     = true
}

variable "additional_min_node_count" {
  description = "Minimum nodes for additional pool autoscaling"
  type        = number
  default     = 1
}

variable "additional_max_node_count" {
  description = "Maximum nodes for additional pool autoscaling"
  type        = number
  default     = 3
}

# AKS Network Variables
variable "aks_network_plugin" {
  description = "Network plugin to use (azure or kubenet)"
  type        = string
  default     = "azure"
  
  validation {
    condition     = contains(["azure", "kubenet"], var.aks_network_plugin)
    error_message = "Network plugin must be either 'azure' or 'kubenet'."
  }
}

variable "aks_network_policy" {
  description = "Network policy to enforce (azure or calico)"
  type        = string
  default     = "azure"
  
  validation {
    condition     = contains(["azure", "calico"], var.aks_network_policy)
    error_message = "Network policy must be either 'azure' or 'calico'."
  }
}

variable "aks_service_cidr" {
  description = "Service CIDR for Kubernetes services"
  type        = string
  default     = "10.1.0.0/16"
}

variable "aks_dns_service_ip" {
  description = "IP address within the Kubernetes service CIDR used by dns service"
  type        = string
  default     = "10.1.0.10"
}

variable "aks_docker_bridge_cidr" {
  description = "IP address (in CIDR notation) used as the Docker bridge IP"
  type        = string
  default     = "172.17.0.1/16"
}

variable "aks_load_balancer_sku" {
  description = "Load Balancer SKU for AKS cluster"
  type        = string
  default     = "standard"
}

# AKS Security Variables
variable "api_server_authorized_ip_ranges" {
  description = "API server authorized IP ranges"
  type        = list(string)
  default     = []
}

variable "enable_rbac" {
  description = "Enable Role-Based Access Control"
  type        = bool
  default     = true
}

variable "enable_azure_ad_rbac" {
  description = "Enable Azure AD RBAC integration"
  type        = bool
  default     = false
}

variable "azure_ad_admin_group_object_ids" {
  description = "Object IDs of Azure AD groups to have admin access"
  type        = list(string)
  default     = []
}

# AKS Monitoring Variables
variable "enable_monitoring" {
  description = "Enable monitoring and logging with Log Analytics"
  type        = bool
  default     = false
}

variable "log_analytics_workspace_id" {
  description = "Log Analytics Workspace ID for monitoring"
  type        = string
  default     = ""
}

# AKS Additional Features
variable "enable_http_app_routing" {
  description = "Enable HTTP application routing addon"
  type        = bool
  default     = false
}

variable "enable_pod_security_policy" {
  description = "Enable Pod Security Policy"
  type        = bool
  default     = false
}

# Azure Container Registry Variables
variable "enable_acr" {
  description = "Create and integrate Azure Container Registry"
  type        = bool
  default     = true
}

variable "acr_name" {
  description = "Name of the Azure Container Registry (must be globally unique, alphanumeric only)"
  type        = string
  default     = "akscr"
}

variable "acr_sku" {
  description = "SKU for Azure Container Registry"
  type        = string
  default     = "Standard"
  
  validation {
    condition     = contains(["Basic", "Standard", "Premium"], var.acr_sku)
    error_message = "ACR SKU must be one of Basic, Standard, or Premium."
  }
}

variable "acr_admin_enabled" {
  description = "Enable admin user for ACR"
  type        = bool
  default     = false
}