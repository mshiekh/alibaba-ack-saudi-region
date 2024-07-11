data "alicloud_zones" "default" {
  available_resource_creation = "VSwitch"
}

resource "alicloud_vpc" "default" {
  vpc_name   = "ack-demo"
  cidr_block = var.vpc_cidr
}

resource "alicloud_vswitch" "default" {
  vswitch_name = "vswitch-1"
  cidr_block   = var.vswitch_cidrs[0]
  vpc_id       = alicloud_vpc.default.id
  zone_id      = data.alicloud_zones.default.zones.0.id
}

data "alicloud_instance_types" "cloud_essd" {
  availability_zone    = data.alicloud_zones.default.zones.0.id
  cpu_core_count       = var.worker_cpu_core_count
  memory_size          = var.worker_memory_size
  kubernetes_node_role = "Worker"
  system_disk_category = "cloud_essd"
}

module "managed-k8s" {
  source                = "./ack-module"
  k8s_name_prefix       = var.ack_name_prefix 
  cluster_spec          = "ack.pro.small"
  vswitch_ids           = [alicloud_vswitch.default.id]
  k8s_pod_cidr          = var.ack_pod_cidr 
  k8s_service_cidr      = var.ack_service_cidr
  kubernetes_version    = var.ack_version
  worker_instance_types = [data.alicloud_instance_types.cloud_essd.instance_types.0.id]
  worker_disk_category  = "cloud_essd"
  cluster_addons = [
    {
      name   = "flannel",
      config = "",
    },
    {
      name   = "flexvolume",
      config = "",
    },
    {
      name   = "alicloud-disk-controller",
      config = "",
    },
    {
      name   = "logtail-ds",
      config = "{\"IngressDashboardEnabled\":\"true\"}",
    },
    {
      name   = "nginx-ingress-controller",
      config = "{\"IngressSlbNetworkType\":\"internet\"}",
    },
  ]

}
