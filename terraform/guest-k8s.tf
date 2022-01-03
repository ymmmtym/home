locals {
  memsize = 4096
  nodes = {
    master = 2
    worker = 3
  }
}

data "template_file" "k8s-master_userdata" {
  count    = local.nodes.master
  template = file("cloud-init/user-data-kube.yml")
  vars = {
    HOSTNAME           = "k8s-master${format("%02d", count.index + 1)}"
    SSH_AUTHORIZED_KEY = file("~/.ssh/kube.id_rsa.pub")
  }
}

data "template_file" "k8s-worker_userdata" {
  count    = local.nodes.worker
  template = file("cloud-init/user-data-kube.yml")
  vars = {
    HOSTNAME           = "k8s-worker${format("%02d", count.index + 1)}"
    SSH_AUTHORIZED_KEY = file("~/.ssh/kube.id_rsa.pub")
  }
}

data "template_file" "k8s_metadata" {
  template = file("cloud-init/meta-data-ubuntu.yml")
}

resource "esxi_resource_pool" "kubernetes" {
  resource_pool_name = "kubernetes"
  cpu_min            = "100"
  cpu_min_expandable = "true"
  cpu_max            = "16000"
  cpu_shares         = "normal"
  mem_min            = local.memsize * 2
  mem_min_expandable = "false"
  mem_max            = local.memsize * 5
  mem_shares         = "normal"
}

resource "esxi_virtual_disk" "k8s-master_1" {
  count                   = local.nodes.master
  virtual_disk_disk_store = var.DISK_STORE
  virtual_disk_dir        = "k8s-master${format("%02d", count.index + 1)}"
  virtual_disk_name       = "k8s-master${format("%02d", count.index + 1)}_1.vmdk"
  virtual_disk_size       = 30
  virtual_disk_type       = "zeroedthick"
}

resource "esxi_virtual_disk" "k8s-worker_1" {
  count                   = local.nodes.worker
  virtual_disk_disk_store = var.DISK_STORE
  virtual_disk_dir        = "k8s-worker${format("%02d", count.index + 1)}"
  virtual_disk_name       = "k8s-worker${format("%02d", count.index + 1)}_1.vmdk"
  virtual_disk_size       = 30
  virtual_disk_type       = "zeroedthick"
}

resource "esxi_guest" "k8s-master" {
  count              = local.nodes.master
  guest_name         = "k8s-master${format("%02d", count.index + 1)}"
  power              = "on"
  disk_store         = var.DISK_STORE
  clone_from_vm      = "template-ubuntu2004"
  memsize            = local.memsize
  numvcpus           = "2"
  resource_pool_name = esxi_resource_pool.kubernetes.resource_pool_name
  boot_disk_size     = "15"
  network_interfaces {
    virtual_network = esxi_portgroup.portgroup100_1.name
    mac_address     = "00:50:56:00:64:${format("%02d", count.index + 4)}"
  }
  network_interfaces {
    virtual_network = esxi_portgroup.portgroup101_1.name
    mac_address     = "00:50:56:00:65:${format("%02d", count.index + 4)}"
  }
  virtual_disks {
    virtual_disk_id = esxi_virtual_disk.k8s-master_1[count.index].id
    slot            = "0:1"
  }
  guestinfo = {
    "metadata.encoding" = "gzip+base64"
    "metadata"          = base64gzip(data.template_file.k8s_metadata.rendered)
    "userdata.encoding" = "gzip+base64"
    "userdata"          = base64gzip(data.template_file.k8s-master_userdata[count.index].rendered)
  }
}

resource "esxi_guest" "k8s-worker" {
  count              = local.nodes.worker
  guest_name         = "k8s-worker${format("%02d", count.index + 1)}"
  power              = "on"
  disk_store         = var.DISK_STORE
  clone_from_vm      = "template-ubuntu2004"
  memsize            = local.memsize
  numvcpus           = "2"
  resource_pool_name = esxi_resource_pool.kubernetes.resource_pool_name
  boot_disk_size     = "15"
  network_interfaces {
    virtual_network = esxi_portgroup.portgroup100_1.name
    mac_address     = "00:50:56:00:64:${format("%02d", local.nodes.master + count.index + 4)}"
  }
  network_interfaces {
    virtual_network = esxi_portgroup.portgroup101_1.name
    mac_address     = "00:50:56:00:65:${format("%02d", local.nodes.master + count.index + 4)}"
  }
  virtual_disks {
    virtual_disk_id = esxi_virtual_disk.k8s-worker_1[count.index].id
    slot            = "0:1"
  }
  guestinfo = {
    "metadata.encoding" = "gzip+base64"
    "metadata"          = base64gzip(data.template_file.k8s_metadata.rendered)
    "userdata.encoding" = "gzip+base64"
    "userdata"          = base64gzip(data.template_file.k8s-worker_userdata[count.index].rendered)
  }
}

