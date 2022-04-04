resource "rke_cluster" "cluster" {
  cluster_name = "cluster"

  nodes {
    address          = esxi_guest.k8s-master.0.ip_address
    internal_address = replace(esxi_guest.k8s-master.0.ip_address, "100", "101")
    user             = "kube"
    ssh_key          = file("~/.ssh/kube.id_rsa")
    role             = ["controlplane", "etcd", "worker"]
  }
  nodes {
    address          = esxi_guest.k8s-master.1.ip_address
    internal_address = replace(esxi_guest.k8s-master.1.ip_address, "100", "101")
    user             = "kube"
    ssh_key          = file("~/.ssh/kube.id_rsa")
    role             = ["controlplane", "etcd", "worker"]
  }
  nodes {
    address          = esxi_guest.k8s-worker.0.ip_address
    internal_address = replace(esxi_guest.k8s-worker.0.ip_address, "100", "101")
    user             = "kube"
    ssh_key          = file("~/.ssh/kube.id_rsa")
    role             = ["worker"]
  }
  nodes {
    address          = esxi_guest.k8s-worker.1.ip_address
    internal_address = replace(esxi_guest.k8s-worker.1.ip_address, "100", "101")
    user             = "kube"
    ssh_key          = file("~/.ssh/kube.id_rsa")
    role             = ["worker"]
  }
  nodes {
    address          = esxi_guest.k8s-worker.2.ip_address
    internal_address = replace(esxi_guest.k8s-worker.2.ip_address, "100", "101")
    user             = "kube"
    ssh_key          = file("~/.ssh/kube.id_rsa")
    role             = ["worker"]
  }
  network {
    plugin = "calico"
  }
  ingress {
    default_backend = false
    provider        = "none"
  }

  delay_on_creation = 30
}

resource "local_file" "kube_cluster_yaml" {
  content  = rke_cluster.cluster.kube_config_yaml
  filename = "kube_config_cluster.yml"
  file_permission = "0600"
}

resource "local_file" "rke_cluster_yaml" {
  content  = rke_cluster.cluster.rke_cluster_yaml
  filename = "cluster.yml"
  file_permission = "0644"
}

resource "local_file" "rke_state" {
  content  = rke_cluster.cluster.rke_state
  filename = "cluster.rkestate"
  file_permission = "0644"
}
