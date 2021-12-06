resource "rke_cluster" "cluster" {
  cluster_name = "cluster"

  nodes {
    address          = esxi_guest.k8s-master01.ip_address
    internal_address = replace(esxi_guest.k8s-master01.ip_address, "100", "101")
    user             = "kube"
    ssh_key          = file("~/.ssh/kube.id_rsa")
    role             = ["controlplane", "etcd"]
  }
  nodes {
    address          = esxi_guest.k8s-master02.ip_address
    internal_address = replace(esxi_guest.k8s-master02.ip_address, "100", "101")
    user             = "kube"
    ssh_key          = file("~/.ssh/kube.id_rsa")
    role             = ["controlplane", "etcd"]
  }
  nodes {
    address          = esxi_guest.k8s-worker01.ip_address
    internal_address = replace(esxi_guest.k8s-worker01.ip_address, "100", "101")
    user             = "kube"
    ssh_key          = file("~/.ssh/kube.id_rsa")
    role             = ["worker"]
  }
  nodes {
    address          = esxi_guest.k8s-worker02.ip_address
    internal_address = replace(esxi_guest.k8s-worker02.ip_address, "100", "101")
    user             = "kube"
    ssh_key          = file("~/.ssh/kube.id_rsa")
    role             = ["worker"]
  }
  nodes {
    address          = esxi_guest.k8s-worker03.ip_address
    internal_address = replace(esxi_guest.k8s-worker03.ip_address, "100", "101")
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
  filename = "kube_config_cluster.yml"
  content  = rke_cluster.cluster.kube_config_yaml
}

resource "local_file" "rke_cluster_yaml" {
  filename = "cluster.yml"
  content  = rke_cluster.cluster.rke_cluster_yaml
}

resource "local_file" "rke_state" {
  filename = "cluster.rkestate"
  content  = rke_cluster.cluster.rke_state
}
