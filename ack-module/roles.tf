// Below are the roles required by ACK.
variable "roles" {
  type = list(object({
    name            = string
    policy_document = string
    description     = string
    policy_name     = string
  }))
  default = [
    {
      name            = "AliyunCSManagedLogRole"
      policy_document = "{\"Statement\":[{\"Action\":\"sts:AssumeRole\",\"Effect\":\"Allow\",\"Principal\":{\"Service\":[\"cs.aliyuncs.com\"]}}],\"Version\":\"1\"}"
      description     = "The logging component of ACK clusters assumes this role to access your resources in other Alibaba Cloud services."
      policy_name     = "AliyunCSManagedLogRolePolicy"
    },
    {
      name            = "AliyunCSManagedCmsRole"
      policy_document = "{\"Statement\":[{\"Action\":\"sts:AssumeRole\",\"Effect\":\"Allow\",\"Principal\":{\"Service\":[\"cs.aliyuncs.com\"]}}],\"Version\":\"1\"}"
      description     = "The CMS component of ACK clusters assumes this role to access your resources in other Alibaba Cloud services."
      policy_name     = "AliyunCSManagedCmsRolePolicy"
    },
    {
      name            = "AliyunCSManagedCsiRole"
      policy_document = "{\"Statement\":[{\"Action\":\"sts:AssumeRole\",\"Effect\":\"Allow\",\"Principal\":{\"Service\":[\"cs.aliyuncs.com\"]}}],\"Version\":\"1\"}"
      description     = "The volume plug-in of ACK clusters assumes this role to access your resources in other Alibaba Cloud services."
      policy_name     = "AliyunCSManagedCsiRolePolicy"
    },
    {
      name            = "AliyunCSManagedVKRole"
      policy_document = "{\"Statement\":[{\"Action\":\"sts:AssumeRole\",\"Effect\":\"Allow\",\"Principal\":{\"Service\":[\"cs.aliyuncs.com\"]}}],\"Version\":\"1\"}"
      description     = "The VK component of ACK Serverless clusters assumes this role to access your resources in other Alibaba Cloud services."
      policy_name     = "AliyunCSManagedVKRolePolicy"
    },
    {
      name            = "AliyunCSClusterRole"
      policy_document = "{\"Statement\":[{\"Action\":\"sts:AssumeRole\",\"Effect\":\"Allow\",\"Principal\":{\"Service\":[\"cs.aliyuncs.com\"]}}],\"Version\":\"1\"}"
      description     = "ACK assumes this role to access your resources in other Alibaba Cloud services in order to run applications."
      policy_name     = "AliyunCSClusterRolePolicy"
    },
    {
      name            = "AliyunCSServerlessKubernetesRole"
      policy_document = "{\"Statement\":[{\"Action\":\"sts:AssumeRole\",\"Effect\":\"Allow\",\"Principal\":{\"Service\":[\"cs.aliyuncs.com\"]}}],\"Version\":\"1\"}"
      description     = "ACK Serverless assumes this role to access your resources in other Alibaba Cloud services by default."
      policy_name     = "AliyunCSServerlessKubernetesRolePolicy"
    },
    {
      name            = "AliyunCSKubernetesAuditRole"
      policy_document = "{\"Statement\":[{\"Action\":\"sts:AssumeRole\",\"Effect\":\"Allow\",\"Principal\":{\"Service\":[\"cs.aliyuncs.com\"]}}],\"Version\":\"1\"}"
      description     = "The auditing feature of ACK assumes this role to access your resources in other Alibaba Cloud services."
      policy_name     = "AliyunCSKubernetesAuditRolePolicy"
    },
    {
      name            = "AliyunCSManagedNetworkRole"
      policy_document = "{\"Statement\":[{\"Action\":\"sts:AssumeRole\",\"Effect\":\"Allow\",\"Principal\":{\"Service\":[\"cs.aliyuncs.com\"]}}],\"Version\":\"1\"}"
      description     = "The network plug-in of ACK clusters assumes this role to access your resources in other Alibaba Cloud services."
      policy_name     = "AliyunCSManagedNetworkRolePolicy"
    },
    {
      name            = "AliyunCSDefaultRole"
      policy_document = "{\"Statement\":[{\"Action\":\"sts:AssumeRole\",\"Effect\":\"Allow\",\"Principal\":{\"Service\":[\"cs.aliyuncs.com\"]}}],\"Version\":\"1\"}"
      description     = "ACK assumes this role to access your resources in other Alibaba Cloud services when managing ACK clusters by default."
      policy_name     = "AliyunCSDefaultRolePolicy"
    },
    {
      name            = "AliyunCSManagedKubernetesRole"
      policy_document = "{\"Statement\":[{\"Action\":\"sts:AssumeRole\",\"Effect\":\"Allow\",\"Principal\":{\"Service\":[\"cs.aliyuncs.com\"]}}],\"Version\":\"1\"}"
      description     = "ACK Managed assumes this role to access your resources in other Alibaba Cloud services by default."
      policy_name     = "AliyunCSManagedKubernetesRolePolicy"
    },
    {
      name            = "AliyunCSManagedArmsRole"
      policy_document = "{\"Statement\":[{\"Action\":\"sts:AssumeRole\",\"Effect\":\"Allow\",\"Principal\":{\"Service\":[\"cs.aliyuncs.com\"]}}],\"Version\":\"1\"}"
      description     = "The ARMS plug-in of ACK clusters assumes this role to access your resources in other Alibaba Cloud services."
      policy_name     = "AliyunCSManagedArmsRolePolicy"
    },
    {
      name            = "AliyunCISDefaultRole"
      policy_document = "{\"Statement\":[{\"Action\":\"sts:AssumeRole\",\"Effect\":\"Allow\",\"Principal\":{\"Service\":[\"cs.aliyuncs.com\"]}}],\"Version\":\"1\"}"
      description     = "Container Intelligence Service assumes this role to access your resources in other Alibaba Cloud services."
      policy_name     = "AliyunCISDefaultRolePolicy"
    },
    {
      name            = "AliyunOOSLifecycleHook4CSRole"
      policy_document = "{\"Statement\":[{\"Action\":\"sts:AssumeRole\",\"Effect\":\"Allow\",\"Principal\":{\"Service\":[\"oos.aliyuncs.com\"]}}],\"Version\":\"1\"}"
      description     = "Operation Orchestration Service (OOS) assumes this role to access your resources in other Alibaba Cloud services. ACK relies on OOS to scale node pools."
      policy_name     = "AliyunOOSLifecycleHook4CSRolePolicy"
    }
  ]
}

// Check for existing roles
data "alicloud_ram_roles" "existing_roles" {
  for_each = { for r in var.roles : r.name => r }
  name_regex = each.value.name
}

// Define local variable to filter roles that need to be created
locals {
  roles_to_create = { for r in var.roles : r.name => r if length(data.alicloud_ram_roles.existing_roles[r.name].roles) == 0 }
}

// Create a role if it does not exist
resource "alicloud_ram_role" "role" {
  for_each    = local.roles_to_create
  name        = each.value.name
  document    = each.value.policy_document
  description = each.value.description
  force       = true
}

// Attach a RAM policy to the role if the role was created
resource "alicloud_ram_role_policy_attachment" "attach" {
  for_each    = local.roles_to_create
  policy_name = each.value.policy_name
  policy_type = "System"
  role_name   = each.value.name
  depends_on  = [alicloud_ram_role.role]
}
