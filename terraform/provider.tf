provider "esxi" {
  esxi_hostname = var.ESXI_HOSTNAME
  esxi_hostport = var.ESXI_HOSTPORT
  esxi_hostssl  = var.ESXI_HOSTSSL
  esxi_username = var.ESXI_USERNAME
  esxi_password = var.ESXI_PASSWORD
}

provider "kubernetes" {
  config_path = rke_cluster.cluster.kube_config_yaml
}
