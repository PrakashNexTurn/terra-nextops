variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
  default     = "myResourceGroup"
}

variable "location" {
  description = "Azure region for resources"
  type        = string
  default     = "eastus"
}

variable "app_service_plan_name" {
  description = "Name of the App Service Plan"
  type        = string
  default     = "myAppServicePlan"
}

variable "app_service_name" {
  description = "Name of the App Service"
  type        = string
  default     = "myAppService"
}

variable "app_service_sku" {
  description = "SKU of the App Service Plan"
  type        = string
  default     = "F1"
  
  validation {
    condition     = contains(["F1", "B1", "B2", "B3", "S1", "S2", "S3"], var.app_service_sku)
    error_message = "App Service SKU must be a valid option (F1, B1, B2, B3, S1, S2, S3)."
  }
}

variable "os_type" {
  description = "OS type for App Service (Linux or Windows)"
  type        = string
  default     = "Linux"
  
  validation {
    condition     = contains(["Linux", "Windows"], var.os_type)
    error_message = "OS type must be either Linux or Windows."
  }
}

variable "runtime_stack" {
  description = "Runtime stack for the app (e.g., PYTHON|3.9, NODE|16-lts)"
  type        = string
  default     = "PYTHON|3.9"
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default = {
    Environment = "Production"
    ManagedBy   = "Terraform"
  }
}
