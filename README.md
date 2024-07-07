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

