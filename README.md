# Terra NextOps - S3 Bucket Terraform Configuration

This repository contains Terraform configuration for provisioning an AWS S3 bucket with best practices.

## Features

- ✅ S3 Bucket creation with customizable naming
- ✅ Bucket versioning (configurable)
- ✅ Server-side encryption (AES256)
- ✅ Public access blocking (configurable)
- ✅ Lifecycle rules for cost optimization (optional)
- ✅ Comprehensive tagging support

## Prerequisites

- [Terraform](https://www.terraform.io/downloads.html) >= 1.0
- AWS Account with appropriate permissions
- AWS CLI configured with credentials

## Quick Start

### 1. Clone the repository

```bash
git clone https://github.com/PrakashNexTurn/terra-nextops.git
cd terra-nextops
```

### 2. Configure variables

Copy the example variables file and update with your values:

```bash
cp terraform.tfvars.example terraform.tfvars
```

Edit `terraform.tfvars` and set your bucket name and other parameters:

```hcl
bucket_name = "your-unique-bucket-name"
aws_region  = "us-east-1"
environment = "dev"
```

### 3. Initialize Terraform

```bash
terraform init
```

### 4. Plan the deployment

```bash
terraform plan
```

### 5. Apply the configuration

```bash
terraform apply
```

Type `yes` when prompted to confirm the deployment.

## Configuration Variables

| Variable | Description | Type | Default | Required |
|----------|-------------|------|---------|----------|
| `aws_region` | AWS region for the S3 bucket | string | `us-east-1` | No |
| `bucket_name` | S3 bucket name (must be globally unique) | string | - | Yes |
| `environment` | Environment name (dev, staging, prod) | string | `dev` | No |
| `enable_versioning` | Enable bucket versioning | bool | `true` | No |
| `block_public_access` | Block all public access | bool | `true` | No |
| `enable_lifecycle_rules` | Enable lifecycle rules | bool | `false` | No |
| `tags` | Additional tags for the bucket | map(string) | `{}` | No |

## Outputs

After successful deployment, Terraform will output:

- `bucket_id` - The name of the bucket
- `bucket_arn` - The ARN of the bucket
- `bucket_domain_name` - The bucket domain name
- `bucket_regional_domain_name` - The bucket region-specific domain name
- `bucket_region` - The AWS region of the bucket

## Security Features

### Encryption
Server-side encryption is enabled by default using AES256.

### Public Access
By default, all public access to the bucket is blocked. This can be configured using the `block_public_access` variable.

### Versioning
Bucket versioning is enabled by default to protect against accidental deletions and overwrites.

## Lifecycle Rules

When `enable_lifecycle_rules` is set to `true`, the following lifecycle policy is applied:

- Objects transition to STANDARD_IA after 30 days
- Objects transition to GLACIER after 90 days
- Objects expire after 365 days

You can modify these rules in `main.tf` according to your requirements.

## Cleanup

To destroy all resources created by this Terraform configuration:

```bash
terraform destroy
```

**Warning**: This will delete the S3 bucket and all its contents. Make sure to backup any important data before running this command.

## File Structure

```
.
├── main.tf                    # Main Terraform configuration
├── variables.tf               # Variable definitions
├── outputs.tf                 # Output definitions
├── terraform.tfvars.example   # Example variables file
└── README.md                  # This file
```

## Best Practices

1. **Bucket Naming**: Ensure your bucket name is globally unique and follows AWS naming conventions
2. **State Management**: Consider using remote state (S3 + DynamoDB) for team collaboration
3. **Credentials**: Never commit AWS credentials to version control
4. **Tagging**: Use consistent tagging for resource management and cost allocation
5. **Versioning**: Keep versioning enabled for production buckets

## Contributing

Feel free to submit issues and pull requests for improvements.

## License

MIT License
