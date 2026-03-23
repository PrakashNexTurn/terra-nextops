# AKS Cluster Deployment Guide

This guide explains how to deploy an Azure Kubernetes Service (AKS) cluster using Terraform.

## Prerequisites

1. **Azure Account**: You need an active Azure subscription
2. **Terraform**: Version 1.0 or higher
3. **Azure CLI**: Install from https://docs.microsoft.com/en-us/cli/azure/install-azure-cli
4. **Service Principal**: For Terraform authentication
5. **kubectl**: Install from https://kubernetes.io/docs/tasks/tools/

## Setup Steps

### 1. Create an Azure Service Principal

```bash
az login

# Create a Service Principal
az ad sp create-for-rbac --role="Contributor" --scopes="/subscriptions/{subscription-id}"
```

This will output:
```json
{
  "appId": "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx",
  "displayName": "azure-cli-xxxx",
  "password": "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx",
  "tenant": "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
}
```

### 2. Get Your Subscription ID

```bash
az account show --query id
```

### 3. Configure Terraform Variables

Copy the example tfvars file and update with your values:

```bash
cp terraform.tfvars.aks.example terraform.tfvars
```

Update `terraform.tfvars` with:
- `azure_subscription_id`: Your subscription ID
- `azure_client_id`: The appId from Service Principal (appId)
- `azure_client_secret`: The password from Service Principal (password)
- `azure_tenant_id`: The tenant from Service Principal (tenant)
- Other configuration as needed

### 4. Initialize Terraform

```bash
terraform init
```

### 5. Review the Plan

```bash
terraform plan
```

### 6. Apply the Configuration

```bash
terraform apply
```

## Post-Deployment

### Get Kubeconfig

After successful deployment, retrieve the kubeconfig:

```bash
az aks get-credentials --resource-group <resource-group-name> --name <cluster-name>
```

Or use the Terraform output:

```bash
$(terraform output -raw kubeconfig_command)
```

### Verify Cluster Access

```bash
kubectl get nodes
kubectl get namespaces
```

## Customization Options

### Enable Azure AD RBAC

Set in `terraform.tfvars`:
```hcl
enable_azure_ad_rbac           = true
azure_ad_admin_group_object_ids = ["xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"]
```

### Enable Monitoring

Set in `terraform.tfvars`:
```hcl
enable_monitoring          = true
log_analytics_workspace_id = "/subscriptions/.../providers/Microsoft.OperationalInsights/workspaces/..."
```

### Create Additional Node Pools

Set in `terraform.tfvars`:
```hcl
create_additional_node_pool = true
additional_node_pool_name   = "nodepool2"
additional_node_count       = 2
additional_node_vm_size     = "Standard_D4s_v3"
```

### Restrict API Server Access

Set authorized IP ranges:
```hcl
api_server_authorized_ip_ranges = ["203.0.113.0/24", "198.51.100.0/24"]
```

## Important Variables

| Variable | Description | Default |
|----------|-------------|---------|n| `aks_cluster_name` | AKS cluster name | aks-cluster |
| `aks_node_count` | Initial number of nodes | 3 |
| `aks_node_vm_size` | VM size for nodes | Standard_D2s_v3 |
| `kubernetes_version` | K8s version | 1.28 |
| `enable_auto_scaling` | Enable autoscaling | true |
| `min_node_count` | Min nodes when autoscaling | 1 |
| `max_node_count` | Max nodes when autoscaling | 5 |
| `enable_acr` | Create ACR | true |

## Outputs

After applying, these outputs will be available:

```bash
terraform output aks_cluster_id
terraform output aks_cluster_fqdn
terraform output kubeconfig_command
terraform output acr_login_server
```

## Destroying the Cluster

To remove all resources:

```bash
terraform destroy
```

## Security Best Practices

1. **API Server Access**: Restrict with `api_server_authorized_ip_ranges`
2. **Azure AD RBAC**: Enable for role-based access control
3. **Network Policy**: Use `aks_network_policy = "azure"` or `"calico"`
4. **Container Registry**: Enable ACR integration
5. **Monitoring**: Enable monitoring with Log Analytics

## Troubleshooting

### Cannot create cluster - quota exceeded

Check your Azure quota limits:
```bash
az compute vm-size list --location "East US"
```

### Service Principal authentication fails

Verify credentials in terraform.tfvars and ensure the Service Principal has Contributor role.

### Cannot access cluster with kubectl

Run:
```bash
az aks get-credentials --resource-group <rg-name> --name <cluster-name> --overwrite-existing
```

## Additional Resources

- [AKS Best Practices](https://docs.microsoft.com/en-us/azure/aks/best-practices)
- [AKS Documentation](https://docs.microsoft.com/en-us/azure/aks/)
- [Terraform AKS Provider](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/kubernetes_cluster)