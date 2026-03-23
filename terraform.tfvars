# Resource Configuration
resource_group_name  = "rg-app-service-nextops"
location             = "eastus"
app_service_plan_name = "asp-nextops-plan"
app_service_name     = "app-nextops-service"
app_insights_name    = "appinsights-nextops"

# App Service Configuration
os_type = "Windows"
sku_name = "B1"

# Optional: Uncomment and set your custom domain
# custom_domain = "yourdomain.com"

# Tags
common_tags = {
  Environment = "Production"
  ManagedBy   = "Terraform"
  Project     = "NextOps"
  CostCenter  = "Engineering"
}