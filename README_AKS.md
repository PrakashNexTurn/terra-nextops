# AKS Infrastructure Setup - Terra-NextOps

## Overview

This Terraform configuration deploys a production-ready **Azure Kubernetes Service (AKS)** cluster along with supporting Azure resources.

## What's Included

### Core AKS Resources
- **Azure Resource Group**: Container for all resources
- **Virtual Network (VNet)**: Network isolation for AKS
- **Subnet**: Dedicated subnet for AKS nodes
- **AKS Cluster**: Kubernetes cluster with configurable node pools
- **Azure Container Registry (ACR)**: Private container image repository
- **Network Policies**: Security and traffic control

### Features
✅ **Autoscaling**: Automatic node scaling based on demand  
✅ **Azure AD Integration**: Optional Azure AD RBAC  
✅ **Monitoring**: Log Analytics integration  
✅ **Security**: RBAC, network policies, API server authorization  
✅ **Multi-Node Pools**: Support for additional node pools  
✅ **Registry Integration**: Seamless ACR integration  

## Quick Start

### Prerequisites

1. **Azure Account** with active subscription
2. **Terraform** >= 1.0
3. **Azure CLI** installed
4. **kubectl** installed
5. **Service Principal** credentials

### Step 1: Create Service Principal

```bash
az login
az ad sp create-for-rbac --role="Contributor" --scopes="/subscriptions/{SUBSCRIPTION_ID}"
```

Save the output values.

### Step 2: Configure Variables

```bash
cp terraform.tfvars.aks.example terraform.tfvars
```

Edit `terraform.tfvars` with your Azure credentials and configuration.

### Step 3: Deploy

```bash
terraform init
terraform plan
terraform apply
```

### Step 4: Access Cluster

```bash
# Using Terraform output
eval $(terraform output -raw kubeconfig_command)

# Or manually
az aks get-credentials --resource-group <rg-name> --name <cluster-name>

# Verify access
kubectl get nodes
```

## File Structure

```
.
├── providers.tf              # AWS & Azure provider configuration
├── main.tf                   # Existing AWS S3 configuration
├── aks.tf                    # AKS cluster and networking resources
├── aks-variables.tf          # AKS configuration variables
├── aks-outputs.tf            # AKS output values
├── variables.tf              # AWS variables
├── outputs.tf                # AWS outputs
├── terraform.tfvars.example  # AWS example values
├── terraform.tfvars.aks.example # AKS example values
├── AKS_DEPLOYMENT_GUIDE.md   # Detailed deployment guide
└── README_AKS.md             # This file
```

## Configuration Variables

### Essential Variables

| Variable | Default | Description |
|----------|---------|-------------|
| `azure_subscription_id` | - | Your Azure subscription ID |
| `azure_client_id` | - | Service Principal app ID |
| `azure_client_secret` | - | Service Principal password |
| `azure_tenant_id` | - | Azure tenant ID |
| `aks_cluster_name` | aks-cluster | Kubernetes cluster name |
| `kubernetes_version` | 1.28 | K8s version |
| `aks_node_count` | 3 | Initial node count |
| `aks_node_vm_size` | Standard_D2s_v3 | Node VM size |

### Optional Features

- **Autoscaling**: `enable_auto_scaling = true`
- **Azure AD RBAC**: `enable_azure_ad_rbac = true`
- **Monitoring**: `enable_monitoring = true`
- **Additional Node Pools**: `create_additional_node_pool = true`
- **HTTP App Routing**: `enable_http_app_routing = true`

See `aks-variables.tf` for all available options.

## Deployment Outputs

After successful deployment, retrieve cluster information:

```bash
# Cluster details
terraform output aks_cluster_id
terraform output aks_cluster_fqdn
terraform output aks_kube_config_raw

# ACR details (if enabled)
terraform output acr_login_server
terraform output acr_name

# Network info
terraform output vnet_id
terraform output subnet_id

# Helper command
terraform output kubeconfig_command
```

## Common Tasks

### Scale Nodes

Edit `terraform.tfvars`:
```hcl
aks_node_count = 5
```

Then apply:
```bash
terraform apply
```

### Add Additional Node Pool

```hcl
create_additional_node_pool = true
additional_node_pool_name   = "gpu-pool"
additional_node_vm_size     = "Standard_NC6s_v3"
```

### Enable Azure AD Integration

```hcl
enable_azure_ad_rbac = true
azure_ad_admin_group_object_ids = ["GROUP_OBJECT_ID"]
```

### Enable Cluster Monitoring

1. Create Log Analytics Workspace (if not exists)
2. Update variables:

```hcl
enable_monitoring = true
log_analytics_workspace_id = "/subscriptions/.../workspaces/..."
```

## Security Best Practices

1. **API Server Access**: Restrict with authorized IP ranges
   ```hcl
   api_server_authorized_ip_ranges = ["203.0.113.0/24"]
   ```

2. **Network Policy**: Enforce traffic rules
   ```hcl
   aks_network_policy = "azure"
   ```

3. **RBAC**: Always enable
   ```hcl
   enable_rbac = true
   ```

4. **Container Registry**: Secure with ACR
   ```hcl
   enable_acr = true
   acr_sku = "Premium"
   ```

5. **Credentials**: Use Terraform sensitive variables
   ```hcl
   azure_client_secret = var.sensitive_secret
   ```

## Troubleshooting

### Quota Issues

```bash
az compute vm-size list --location "East US"
```

### Authentication Failures

- Verify Service Principal credentials
- Ensure SP has Contributor role
- Check subscription ID

### Kubectl Connection Issues

```bash
az aks get-credentials --resource-group <rg> --name <cluster> --overwrite-existing
```

### ACR Access Issues

```bash
# Grant AKS access to ACR
az role assignment create \
  --assignee <aks-identity-id> \
  --role AcrPull \
  --scope <acr-id>
```

## Cleanup

To destroy all resources:

```bash
terraform destroy
```

⚠️ **Warning**: This will delete all AKS resources and data.

## Cost Optimization

- Use smaller VM sizes for dev/test
- Enable autoscaling to reduce idle resources
- Use spot instances for non-critical workloads
- Review and adjust node pool configuration regularly

## Advanced Topics

### Custom Network Configuration

Modify network variables for custom CIDR ranges:
```hcl
aks_vnet_address_space    = ["10.0.0.0/8"]
aks_subnet_address_prefixes = ["10.1.0.0/16"]
aks_service_cidr          = "172.16.0.0/12"
```

### Using Terraform Workspaces

```bash
terraform workspace new production
terraform workspace select production
terraform apply
```

### State Management

For production:
```bash
# Enable backend storage
terraform {
  backend "azurerm" {
    resource_group_name  = "terraform-state"
    storage_account_name = "tfstate"
    container_name       = "state"
    key                  = "aks.tfstate"
  }
}
```

## References

- [AKS Documentation](https://docs.microsoft.com/azure/aks/)
- [Terraform AzureRM Provider](https://registry.terraform.io/providers/hashicorp/azurerm/latest)
- [AKS Best Practices](https://docs.microsoft.com/azure/aks/best-practices)
- [Kubernetes Documentation](https://kubernetes.io/docs/)

## Support

For issues or questions:
1. Check `AKS_DEPLOYMENT_GUIDE.md` for detailed instructions
2. Review Terraform logs: `TF_LOG=DEBUG terraform apply`
3. Consult Azure documentation
4. File issues in repository

---

**Branch**: `feature/aks-creation`  
**Last Updated**: 2026-03-23  
**Maintainer**: DevOps Team
