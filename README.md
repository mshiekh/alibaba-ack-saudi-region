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
  vswitch_cidrs = ["10.10.1.0/24"]
  worker_instance_type = "ecs.c6.large"
  worker_numbers = 2
  ```
3. **Get the ACCESS_KEY and SECRET_KEY**
   Go to RAM > Click on your user account > unders **AccessKey** click  the button Create Access Key

4. **Use aliyun cli to configure your profile**
   I found more convenient to set the profile use aliyun cli and then reference it using  `profile` in the provider.tf. You can check the [example usage](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs#example-usage) and use the method you prefer.
   follow the steps below and you should get the Welcome message if all is set correctly:
   ```bash
   aliyun configure --profile "profilename"
   Configuring profile 'profilename' in '' authenticate mode...
   Access Key Id []: #**Copy and paste your Access key**
   Access Key Secret []: #**Copy and paste your Access key**
   Default Region Id []: me-central-1
   Default Output Format [json]: json (Only support json))
   Default Language [zh|en] en:
   Saving profile[profilename] ...Done.
   available regions:
    cn-hongkong
    ap-northeast-1
    ap-southeast-1
    ap-southeast-2
    ap-southeast-3
    ap-southeast-6
    ap-southeast-5
    ap-south-1
    us-east-1
    us-west-1
    eu-west-1
    me-east-1
    me-central-1
    eu-central-1
    
    Configure Done!!!
    ..............888888888888888888888 ........=8888888888888888888D=..............
    ...........88888888888888888888888 ..........D8888888888888888888888I...........
    .........,8888888888888ZI: ...........................=Z88D8888888888D..........
    .........+88888888 ..........................................88888888D..........
    .........+88888888 .......Welcome to use Alibaba Cloud.......O8888888D..........
    .........+88888888 ............. ************* ..............O8888888D..........
    .........+88888888 .... Command Line Interface(Reloaded) ....O8888888D..........
    .........+88888888...........................................88888888D..........
    ..........D888888888888DO+. ..........................?ND888888888888D..........
    ...........O8888888888888888888888...........D8888888888888888888888=...........
    ............ .:D8888888888888888888.........78888888888888888888O ..............
    ```
5. **Initialize Terraform:**
   ```bash
   terraform init
   ```
6. **Plan the Configuration:**
   ```bash
   terraform plan
   ```

7. **Apply the Configuration:**
   ```bash
   terraform apply
   ```

Confirm the apply with yes when prompted.

8. **Verify the Deployment:**
  After the apply completes, verify that the resources were created successfully in the Alibaba Cloud Console. and the kubeconfig file will be generated `config`, copy it to the `~/.kube/config` or the location where you configure kubeconfig and you should be able to access the ACK cluster
```bash
  kubectl get no
```
  ![image](https://github.com/mshiekh/alibaba-ack-saudi-region/assets/66517402/5086401a-ed84-4821-b161-4892b444d371)


![image](https://github.com/mshiekh/alibaba-ack-saudi-region/assets/66517402/3c0bbba3-e5b7-4e95-8214-7e8beca82e89)


