### locals

locals {
  numvcpus  = 2
  memsize   = 4096
  disk_size = 30

  ssh_authorized_key = file("~/.ssh/kube.id_rsa.pub")

  nodes = {
    haproxy = 0
    server  = 3
    agent   = 3
  }
}


### common

resource "esxi_resource_pool" "kubernetes" {
  resource_pool_name = "kubernetes"
  cpu_min            = "100"
  cpu_min_expandable = "true"
  cpu_max            = "16000"
  cpu_shares         = "normal"
  mem_min            = local.memsize * 2
  mem_min_expandable = "false"
  mem_max            = local.memsize * 12
  mem_shares         = "normal"
}

data "template_file" "rke2_metadata" {
  template = file("cloud-init/meta-data-ubuntu.yml")
}

resource "random_password" "rke2_token" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}


### HAProxy for RKE2 Server

data "template_file" "rke2-haproxy_haproxy" {
  template = file("haproxy/haproxy.cfg.tftpl")
}

data "template_file" "rke2-haproxy_keepalived" {
  count    = local.nodes.haproxy
  template = file("keepalived/keepalived.conf.tftpl")
  vars = {
    STATE     = count.index == 0 ? "MASTER" : "BACKUP"
    INTERFACE = "ens32"
    PRIORITY  = count.index == 0 ? "150" : "100"
  }
}

data "template_file" "rke2-haproxy_userdata" {
  count    = local.nodes.haproxy
  template = file("cloud-init/user-data-haproxy.yml")
  vars = {
    HOSTNAME           = "rke2-haproxy${format("%02d", count.index + 1)}"
    SSH_AUTHORIZED_KEY = local.ssh_authorized_key
    HAPROXY_CFG        = base64gzip(data.template_file.rke2-haproxy_haproxy.rendered)
    KEEPALIVED_CONF    = base64gzip(data.template_file.rke2-haproxy_keepalived[count.index].rendered)
  }
}

resource "esxi_guest" "rke2-haproxy" {
  count              = local.nodes.haproxy
  guest_name         = "rke2-haproxy${format("%02d", count.index + 1)}"
  power              = "on"
  disk_store         = var.DISK_STORE
  clone_from_vm      = "template-ubuntu2004"
  memsize            = local.memsize
  numvcpus           = local.numvcpus
  resource_pool_name = esxi_resource_pool.kubernetes.resource_pool_name
  boot_disk_size     = "15"
  network_interfaces {
    virtual_network = esxi_portgroup.portgroup100_1.name
    mac_address     = "00:50:56:00:64:${format("%02X", 5 + count.index)}"
  }
  network_interfaces {
    virtual_network = esxi_portgroup.portgroup101_1.name
    mac_address     = "00:50:56:00:65:${format("%02X", 5 + count.index)}"
  }
  guestinfo = {
    "metadata.encoding" = "gzip+base64"
    "metadata"          = base64gzip(data.template_file.rke2_metadata.rendered)
    "userdata.encoding" = "gzip+base64"
    "userdata"          = base64gzip(data.template_file.rke2-haproxy_userdata[count.index].rendered)
  }
}


### RKE2 Server

data "template_file" "rke2-server_keepalived" {
  count    = local.nodes.server
  template = file("keepalived/keepalived.conf.tftpl")
  vars = {
    STATE     = count.index == 0 ? "MASTER" : "BACKUP"
    INTERFACE = "ens32"
    PRIORITY  = count.index == 0 ? "150" : "100"
  }
}

data "template_file" "rke2-server_config" {
  count    = local.nodes.server
  template = file("rke2/config.yaml.tftpl")
  vars = {
    FIRST_SERVER      = count.index == 0 ? "" : "rke2-server01"
    TOKEN             = random_password.rke2_token.result
    INSTALL_RKE2_TYPE = "server"
    TLS_SAN           = "[rke2-server, rke2-server01, rke2-server02, rke-server03]"
  }
}

data "template_file" "rke2-server_manifests" {
  template = file("rke2/manifests.yaml.tftpl")
}

data "template_file" "rke2-server_userdata" {
  count    = local.nodes.server
  template = file("cloud-init/user-data-rke2.yml")
  vars = {
    KEEPALIVED_CONF    = base64gzip(data.template_file.rke2-server_keepalived[count.index].rendered)
    HOSTNAME           = "rke2-server${format("%02d", count.index + 1)}"
    SSH_AUTHORIZED_KEY = local.ssh_authorized_key
    INSTALL_RKE2_TYPE  = "server"
    RKE2_CONFIG        = base64gzip(data.template_file.rke2-server_config[count.index].rendered)
    MANIFESTS          = base64gzip(data.template_file.rke2-server_manifests.rendered)
  }
}

resource "esxi_virtual_disk" "rke2-server_1" {
  count                   = local.nodes.server
  virtual_disk_disk_store = var.DISK_STORE
  virtual_disk_dir        = "rke2-server${format("%02d", count.index + 1)}"
  virtual_disk_name       = "rke2-server${format("%02d", count.index + 1)}_1.vmdk"
  virtual_disk_size       = local.disk_size
  virtual_disk_type       = "zeroedthick"
}

resource "esxi_guest" "rke2-server" {
  count              = local.nodes.server
  guest_name         = "rke2-server${format("%02d", count.index + 1)}"
  power              = "on"
  disk_store         = var.DISK_STORE
  clone_from_vm      = "template-ubuntu2004"
  memsize            = local.memsize * 2
  numvcpus           = local.numvcpus
  resource_pool_name = esxi_resource_pool.kubernetes.resource_pool_name
  boot_disk_size     = "15"
  network_interfaces {
    virtual_network = esxi_portgroup.portgroup100_1.name
    mac_address     = "00:50:56:00:64:${format("%02X", 5 + local.nodes.haproxy + count.index)}"
  }
  network_interfaces {
    virtual_network = esxi_portgroup.portgroup101_1.name
    mac_address     = "00:50:56:00:65:${format("%02X", 5 + local.nodes.haproxy + count.index)}"
  }
  virtual_disks {
    virtual_disk_id = esxi_virtual_disk.rke2-server_1[count.index].id
    slot            = "0:1"
  }
  guestinfo = {
    "metadata.encoding" = "gzip+base64"
    "metadata"          = base64gzip(data.template_file.rke2_metadata.rendered)
    "userdata.encoding" = "gzip+base64"
    "userdata"          = base64gzip(data.template_file.rke2-server_userdata[count.index].rendered)
  }
}

resource "null_resource" "update_kubeconfig" {
  triggers = {
    rke2-server-ids = join(",", esxi_guest.rke2-server.*.id)
  }

  provisioner "local-exec" {
    command = <<-EOF
    TMP_KUBECONFIG=$(mktemp)
    rm $TMP_KUBECONFIG
    while [ ! -e $TMP_KUBECONFIG ]; do scp rke2-server:~/.kube/config $TMP_KUBECONFIG; sleep 10; done
    sed -i.bak "s/127\.0\.0\.1/rke2-server/g" $TMP_KUBECONFIG
    kubectl config delete-context default
    kubectl config delete-cluster default
    kubectl config delete-user default
    NEW_KUBECONFIG=$(KUBECONFIG=~/.kube/config:$TMP_KUBECONFIG kubectl config view --flatten)
    IFS=''
    echo $NEW_KUBECONFIG > ~/.kube/config
    rm $TMP_KUBECONFIG{,.bak}
    EOF
  }
}


### RKE2 Agent

data "template_file" "rke2-agent_config" {
  template = file("rke2/config.yaml.tftpl")
  vars = {
    FIRST_SERVER      = "rke2-server01"
    TOKEN             = random_password.rke2_token.result
    INSTALL_RKE2_TYPE = "agent"
  }
}

data "template_file" "rke2-agent_userdata" {
  count    = local.nodes.agent
  template = file("cloud-init/user-data-rke2.yml")
  vars = {
    HOSTNAME           = "rke2-agent${format("%02d", count.index + 1)}"
    SSH_AUTHORIZED_KEY = local.ssh_authorized_key
    INSTALL_RKE2_TYPE  = "agent"
    RKE2_CONFIG        = base64gzip(data.template_file.rke2-agent_config.rendered)
  }
}

resource "esxi_virtual_disk" "rke2-agent_1" {
  count                   = local.nodes.agent
  virtual_disk_disk_store = var.DISK_STORE
  virtual_disk_dir        = "rke2-agent${format("%02d", count.index + 1)}"
  virtual_disk_name       = "rke2-agent${format("%02d", count.index + 1)}_1.vmdk"
  virtual_disk_size       = local.disk_size
  virtual_disk_type       = "zeroedthick"
}

resource "esxi_guest" "rke2-agent" {
  count              = local.nodes.agent
  guest_name         = "rke2-agent${format("%02d", count.index + 1)}"
  power              = "on"
  disk_store         = var.DISK_STORE
  clone_from_vm      = "template-ubuntu2004"
  memsize            = local.memsize
  numvcpus           = local.numvcpus
  resource_pool_name = esxi_resource_pool.kubernetes.resource_pool_name
  boot_disk_size     = "15"
  network_interfaces {
    virtual_network = esxi_portgroup.portgroup100_1.name
    mac_address     = "00:50:56:00:64:${format("%02X", 5 + local.nodes.haproxy + local.nodes.server + count.index)}"
  }
  network_interfaces {
    virtual_network = esxi_portgroup.portgroup101_1.name
    mac_address     = "00:50:56:00:65:${format("%02X", 5 + local.nodes.haproxy + local.nodes.server + count.index)}"
  }
  virtual_disks {
    virtual_disk_id = esxi_virtual_disk.rke2-agent_1[count.index].id
    slot            = "0:1"
  }
  guestinfo = {
    "metadata.encoding" = "gzip+base64"
    "metadata"          = base64gzip(data.template_file.rke2_metadata.rendered)
    "userdata.encoding" = "gzip+base64"
    "userdata"          = base64gzip(data.template_file.rke2-agent_userdata[count.index].rendered)
  }
}


### Bootstrap

# kubernetes

provider "kubernetes" {
  config_path    = "~/.kube/config"
  config_context = "default"
}

resource "tls_private_key" "sealed-secret-key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "tls_self_signed_cert" "sealed-secret-key" {
  private_key_pem = tls_private_key.sealed-secret-key.private_key_pem

  validity_period_hours = 26280 # 3y
  early_renewal_hours   = 8760  # 365d

  is_ca_certificate = true

  allowed_uses = ["cert_signing"]

  subject {
    common_name  = "yumenomatayume.net"
  }
}

resource "kubernetes_secret" "sealed-secret-key" {
  metadata {
    name      = "sealed-secret-key"
    namespace = "kube-system"
		labels    = {
			"sealedsecrets.bitnami.com/sealed-secrets-key" = "active"
		}
  }

  data = {
    "tls.crt" = tls_self_signed_cert.sealed-secret-key.cert_pem
    "tls.key" = tls_private_key.sealed-secret-key.private_key_pem
  }

  type = "kubernetes.io/tls"

  depends_on = [null_resource.update_kubeconfig]
}


# Helm

provider "helm" {
  kubernetes {
    config_path    = "~/.kube/config"
    config_context = "default"
  }
}

data "http" "rke2-server_argocd_values" {
  url = "https://raw.githubusercontent.com/ymmmtym/manifests/main/argo-cd/overlays/dev/values.yaml"
}

resource "helm_release" "argo-cd" {
  name       = "argo-cd"
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  version    = "4.5.7"
  namespace  = "argocd"

  create_namespace = true

  values = [data.http.rke2-server_argocd_values.body]

  depends_on = [null_resource.update_kubeconfig]
}
