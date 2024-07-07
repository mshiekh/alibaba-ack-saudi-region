# Alibaba Cloud ACK Provisioning with Terraform

This repository provides a Terraform configuration to provision an Alibaba Cloud Kubernetes (ACK) cluster in the Saudi region. 

## Prerequisites

- Terraform installed on your local machine.
- Alibaba Cloud CLI configured with the necessary credentials.
- An existing RAM role with sufficient permissions to create resources.

## Provider Configuration

The `provider.tf` file configures the Alibaba Cloud provider. Ensure you update the `role_arn` with the existing actual role ARN of 'operator-role'. this is needed as the console uses this role to create the resources. you can use the profile configured with aliyun cli or use the ACCESS_KEY and SECRET_KEY. either way, make sure to assume the role of the 'operator-role' or you will face access issue to the cluster

```hcl
provider "alicloud" {
  profile     = "your-profile"
  region      = "me-central-1"
  assume_role {
    role_arn = "acs:ram::111222333444555:role/operator-role" # Replace with your actual role ARN for operator-role
  }
}
```
## How to Use This Terraform Configuration

This section provides instructions on how to use the Terraform configuration to provision an Alibaba Cloud Kubernetes (ACK) cluster in the Saudi region.

### Prerequisites

- Ensure you have [Terraform](https://www.terraform.io/downloads.html) installed on your local machine.
- Configure the Alibaba Cloud CLI with the necessary credentials. (optional)
- Ensure you have the appropriate permissions and the necessary RAM role for creating resources. (this setup was used with `AdministratorAccess` assigned to alibaba account)

### Steps to Use Terraform

1. **Clone the Repository**:
   Clone this repository to your local machine:
   ```bash
   git clone https://github.com/mshiekh/alibaba-ack-saudi-region.git
   cd alibaba-ack-saudi-region
2. **Customize Variables:**
   Edit the variables.tf file or create a terraform.tfvars file to customize the variables such as the VSwitch ID:
   ```bash
   nano terraform.tfvars

Example terraform.tfvars:

  ```hcl
  ack_cluster_name = "my-ack-cluster"
  vswitch_id = "your-vswitch-id"
  worker_instance_type = "ecs.c6.large"
  worker_numbers = 2
  ```
3. **Initialize Terraform:**
   ```bash
   terraform init
   ```
4. **Plan the Configuration:**
   ```bash
   terraform plan
   ```

5. **Apply the Configuration:**
   ```bash
   terraform apply
   ```

Confirm the apply with yes when prompted.

6. **Verify the Deployment:**
  After the apply completes, verify that the resources were created successfully in the Alibaba Cloud Console. and the kubeconfig file will be generated `config`, copy it to the `~/.kube/config` or the location where you configure kubeconfig and you should be able to access the ACK cluster
