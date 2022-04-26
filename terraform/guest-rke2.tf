### locals

locals {
  numvcpus  = 2
  memsize   = 4096
  disk_size = 30

  ssh_authorized_key = file("~/.ssh/kube.id_rsa.pub")

  nodes = {
    haproxy = 2
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


### HAProxy for RKE2 Server

data "template_file" "rke2-haproxy_userdata" {
  count    = local.nodes.haproxy
  template = file("cloud-init/user-data-haproxy.yml")
  vars = {
    HOSTNAME           = "rke2-haproxy${format("%02d", count.index + 1)}"
    SSH_AUTHORIZED_KEY = local.ssh_authorized_key
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

data "template_file" "rke2-server_userdata" {
  count    = local.nodes.server
  template = file("cloud-init/user-data-rke2.yml")
  vars = {
    HOSTNAME           = "rke2-server${format("%02d", count.index + 1)}"
    SSH_AUTHORIZED_KEY = local.ssh_authorized_key
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


### RKE2 Agent

data "template_file" "rke2-agent_userdata" {
  count    = local.nodes.agent
  template = file("cloud-init/user-data-rke2.yml")
  vars = {
    HOSTNAME           = "rke2-agent${format("%02d", count.index + 1)}"
    SSH_AUTHORIZED_KEY = local.ssh_authorized_key
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

