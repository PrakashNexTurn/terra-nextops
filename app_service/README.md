# Azure App Service Terraform Configuration

This Terraform configuration creates an Azure App Service with all necessary components.

## Prerequisites

- Terraform >= 1.0
- Azure CLI installed and authenticated
- Azure subscription

## Resources Created

- **Resource Group**: Container for all resources
- **App Service Plan**: Defines compute resources and pricing tier
- **App Service**: Web application hosting environment

## Usage

### 1. Initialize Terraform
```bash
cd app_service
terraform init
```

### 2. Create terraform.tfvars
```bash
cp terraform.tfvars.example terraform.tfvars
# Edit terraform.tfvars with your values
```

### 3. Plan the deployment
```bash
terraform plan
```

### 4. Apply the configuration
```bash
terraform apply
```

### 5. Get outputs
```bash
terraform output
```

## Configuration Variables

- `resource_group_name`: Name of the Azure resource group (default: "myResourceGroup")
- `location`: Azure region (default: "eastus")
- `app_service_plan_name`: Name of the App Service Plan
- `app_service_name`: Name of the App Service
- `app_service_sku`: Pricing tier (F1/B1/B2/B3/S1/S2/S3)
- `os_type`: Operating system type (Linux or Windows)
- `runtime_stack`: Runtime environment (e.g., PYTHON|3.9)
- `tags`: Resource tags for organization and billing

## Outputs

- `app_service_default_hostname`: Default URL of your app service
- `app_service_outbound_ip_addresses`: Outbound IP addresses
- `app_service_id`: Resource ID

## Security Features

- HTTPS only enabled
- Minimum TLS version 1.2
- Proper authentication and authorization setup

## Cost Optimization

- Free tier (F1) available for development/testing
- Scalable pricing based on demand

## Cleanup

To remove all resources:
```bash
terraform destroy
```

## Support

For issues or questions, please contact the DevOps team.
