variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
  default     = "rg-app-service-nextops"
}

variable "location" {
  description = "Azure region for resources"
  type        = string
  default     = "eastus"
}

variable "app_service_plan_name" {
  description = "Name of the App Service Plan"
  type        = string
  default     = "asp-nextops-plan"
}

variable "app_service_name" {
  description = "Name of the App Service"
  type        = string
  default     = "app-nextops-service"
}

variable "app_insights_name" {
  description = "Name of Application Insights"
  type        = string
  default     = "appinsights-nextops"
}

variable "os_type" {
  description = "OS type for App Service Plan (Windows, Linux, etc.)"
  type        = string
  default     = "Windows"
  
  validation {
    condition     = contains(["Windows", "Linux"], var.os_type)
    error_message = "OS type must be either 'Windows' or 'Linux'."
  }
}

variable "sku_name" {
  description = "SKU name for App Service Plan (e.g., B1, B2, B3, S1, S2, S3, P1v2, P2v2, P3v2)"
  type        = string
  default     = "B1"
  
  validation {
    condition     = contains(["B1", "B2", "B3", "S1", "S2", "S3", "P1v2", "P2v2", "P3v2"], var.sku_name)
    error_message = "SKU name must be a valid Azure App Service Plan SKU."
  }
}

variable "custom_domain" {
  description = "Custom domain name for the App Service (optional)"
  type        = string
  default     = null
}

variable "common_tags" {
  description = "Common tags to apply to all resources"
  type        = map(string)
  default = {
    Environment = "Production"
    ManagedBy   = "Terraform"
    Project     = "NextOps"
  }
}