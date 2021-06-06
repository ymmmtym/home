data "template_file" "k8s_master1" {
  template = file("user-data.yml")
  vars = {
    HOSTNAME = "k8s-master1"
  }
}
data "template_file" "k8s_worker1" {
  template = file("user-data.yml")
  vars = {
    HOSTNAME = "k8s-worker1"
  }
}
data "template_file" "k8s_worker2" {
  template = file("user-data.yml")
  vars = {
    HOSTNAME = "k8s-worker2"
  }
}

resource "esxi_guest" "k8s-master1" {
  guest_name         = "k8s-master1"
  power              = "on"
  disk_store         = var.DISK_STORE
  clone_from_vm      = "template-ubuntu2004"
  memsize            = "4096"
  numvcpus           = "1"
  boot_disk_size     = "30"
  network_interfaces {
    virtual_network  = esxi_portgroup.portgroup100_1.name
    mac_address      = "00:50:56:00:64:04"
  }
  network_interfaces {
    virtual_network  = esxi_portgroup.portgroup101_1.name
    mac_address      = "00:50:56:00:65:04"
  }
  guestinfo = {
    "userdata.encoding" = "gzip+base64"
    "userdata"          = base64gzip(data.template_file.k8s_master1.rendered)
  }
}
resource "esxi_guest" "k8s-worker1" {
  guest_name         = "k8s-worker1"
  power              = "on"
  disk_store         = var.DISK_STORE
  clone_from_vm      = "template-ubuntu2004"
  memsize            = "4096"
  numvcpus           = "1"
  boot_disk_size     = "30"
  network_interfaces {
    virtual_network  = esxi_portgroup.portgroup100_1.name
    mac_address      = "00:50:56:00:64:05"
  }
  network_interfaces {
    virtual_network  = esxi_portgroup.portgroup101_1.name
    mac_address      = "00:50:56:00:65:05"
  }
  guestinfo = {
    "userdata.encoding" = "gzip+base64"
    "userdata"          = base64gzip(data.template_file.k8s_worker1.rendered)
  }
}
resource "esxi_guest" "k8s-worker2" {
  guest_name         = "k8s-worker2"
  power              = "on"
  disk_store         = var.DISK_STORE
  clone_from_vm      = "template-ubuntu2004"
  memsize            = "4096"
  numvcpus           = "1"
  boot_disk_size     = "30"
  network_interfaces {
    virtual_network  = esxi_portgroup.portgroup100_1.name
    mac_address      = "00:50:56:00:64:06"
  }
  network_interfaces {
    virtual_network  = esxi_portgroup.portgroup101_1.name
    mac_address      = "00:50:56:00:65:06"
  }
  guestinfo = {
    "userdata.encoding" = "gzip+base64"
    "userdata"          = base64gzip(data.template_file.k8s_worker2.rendered)
  }
}
