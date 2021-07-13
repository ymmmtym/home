variable "MEMSIZE" { default = "4096" }

data "template_file" "k8s-master01_userdata" {
  template = file("cloud-init/user-data-kube.yml")
  vars = {
    HOSTNAME           = "k8s-master01"
    SSH_AUTHORIZED_KEY = file("~/.ssh/id_rsa.kube.pub")
  }
}
data "template_file" "k8s-worker01_userdata" {
  template = file("cloud-init/user-data-kube.yml")
  vars = {
    HOSTNAME           = "k8s-worker01"
    SSH_AUTHORIZED_KEY = file("~/.ssh/id_rsa.kube.pub")
  }
}
data "template_file" "k8s-worker02_userdata" {
  template = file("cloud-init/user-data-kube.yml")
  vars = {
    HOSTNAME           = "k8s-worker02"
    SSH_AUTHORIZED_KEY = file("~/.ssh/id_rsa.kube.pub")
  }
}

data "template_file" "k8s_metadata" {
  template = file("cloud-init/meta-data-ubuntu.yml")
}

resource "esxi_resource_pool" "kubernetes" {
  resource_pool_name = "kubernetes"
  cpu_min            = "100"
  cpu_min_expandable = "true"
  cpu_max            = "8000"
  cpu_shares         = "normal"
  mem_min            = "200"
  mem_min_expandable = "false"
  mem_max            = "16384"
  mem_shares         = "normal"
}

resource "esxi_virtual_disk" "k8s-master01_1" {
  virtual_disk_disk_store = var.DISK_STORE
  virtual_disk_dir        = "k8s-master01"
  virtual_disk_name       = "k8s-master01_1.vmdk"
  virtual_disk_size       = 30
  virtual_disk_type       = "zeroedthick"
}
resource "esxi_virtual_disk" "k8s-worker01_1" {
  virtual_disk_disk_store = var.DISK_STORE
  virtual_disk_dir        = "k8s-worker01"
  virtual_disk_name       = "k8s-worker01_1.vmdk"
  virtual_disk_size       = 30
  virtual_disk_type       = "zeroedthick"
}
resource "esxi_virtual_disk" "k8s-worker02_1" {
  virtual_disk_disk_store = var.DISK_STORE
  virtual_disk_dir        = "k8s-worker02"
  virtual_disk_name       = "k8s-worker02_1.vmdk"
  virtual_disk_size       = 30
  virtual_disk_type       = "zeroedthick"
}

resource "esxi_guest" "k8s-master01" {
  guest_name         = "k8s-master01"
  power              = "on"
  disk_store         = var.DISK_STORE
  clone_from_vm      = "template-ubuntu2004"
  memsize            = "4096"
  numvcpus           = "2"
  resource_pool_name = esxi_resource_pool.kubernetes.resource_pool_name
  boot_disk_size     = "15"
  network_interfaces {
    virtual_network = esxi_portgroup.portgroup100_1.name
    mac_address     = "00:50:56:00:64:04"
  }
  network_interfaces {
    virtual_network = esxi_portgroup.portgroup101_1.name
    mac_address     = "00:50:56:00:65:04"
  }
  virtual_disks {
    virtual_disk_id = esxi_virtual_disk.k8s-master01_1.id
    slot            = "0:1"
  }
  guestinfo = {
    "metadata.encoding" = "gzip+base64"
    "metadata"          = base64gzip(data.template_file.k8s_metadata.rendered)
    "userdata.encoding" = "gzip+base64"
    "userdata"          = base64gzip(data.template_file.k8s-master01_userdata.rendered)
  }
}
resource "esxi_guest" "k8s-worker01" {
  guest_name         = "k8s-worker01"
  power              = "on"
  disk_store         = var.DISK_STORE
  clone_from_vm      = "template-ubuntu2004"
  memsize            = "4096"
  numvcpus           = "2"
  resource_pool_name = esxi_resource_pool.kubernetes.resource_pool_name
  boot_disk_size     = "15"
  network_interfaces {
    virtual_network = esxi_portgroup.portgroup100_1.name
    mac_address     = "00:50:56:00:64:05"
  }
  network_interfaces {
    virtual_network = esxi_portgroup.portgroup101_1.name
    mac_address     = "00:50:56:00:65:05"
  }
  virtual_disks {
    virtual_disk_id = esxi_virtual_disk.k8s-worker01_1.id
    slot            = "0:1"
  }
  guestinfo = {
    "metadata.encoding" = "gzip+base64"
    "metadata"          = base64gzip(data.template_file.k8s_metadata.rendered)
    "userdata.encoding" = "gzip+base64"
    "userdata"          = base64gzip(data.template_file.k8s-worker01_userdata.rendered)
  }
  depends_on = [
    esxi_guest.k8s-master01,
  ]
}

resource "esxi_guest" "k8s-worker02" {
  guest_name         = "k8s-worker02"
  power              = "on"
  disk_store         = var.DISK_STORE
  clone_from_vm      = "template-ubuntu2004"
  memsize            = "4096"
  numvcpus           = "2"
  resource_pool_name = esxi_resource_pool.kubernetes.resource_pool_name
  boot_disk_size     = "70"
  network_interfaces {
    virtual_network = esxi_portgroup.portgroup100_1.name
    mac_address     = "00:50:56:00:64:06"
  }
  network_interfaces {
    virtual_network = esxi_portgroup.portgroup101_1.name
    mac_address     = "00:50:56:00:65:06"
  }
  virtual_disks {
    virtual_disk_id = esxi_virtual_disk.k8s-worker02_1.id
    slot            = "0:1"
  }
  guestinfo = {
    "metadata.encoding" = "gzip+base64"
    "metadata"          = base64gzip(data.template_file.k8s_metadata.rendered)
    "userdata.encoding" = "gzip+base64"
    "userdata"          = base64gzip(data.template_file.k8s-worker02_userdata.rendered)
  }
}
