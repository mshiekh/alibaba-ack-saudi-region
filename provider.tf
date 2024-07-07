provider "alicloud" {
  profile     = "demo2"
  region      = "me-central-1"
 assume_role {
    role_arn = "acs:ram::111222333444555:role/operator-role" # Replace with your actual role ARN
  }
}
