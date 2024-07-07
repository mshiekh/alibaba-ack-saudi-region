provider "alicloud" {
  profile     = "demo3"
  region      = "me-central-1"
 assume_role {
    role_arn = "acs:ram::5755820362346675:role/operator-role" # Replace with your actual role ARN
  }
}
