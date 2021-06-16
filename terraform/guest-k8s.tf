data "template_file" "k8s_master1_userdata" {
  template = file("user-data-kube.yml")
  vars = {
    HOSTNAME = "k8s-master1"
  }
}
data "template_file" "k8s_worker1_userdata" {
  template = file("user-data-kube.yml")
  vars = {
    HOSTNAME = "k8s-worker1"
  }
}
data "template_file" "k8s_worker2_userdata" {
  template = file("user-data-kube.yml")
  vars = {
    HOSTNAME = "k8s-worker2"
  }
}

data "template_file" "k8s_master1_metadata" {
  template = file("meta-data-ubuntu.yml")
  vars = {
    HOSTNAME = "k8s-master1"
  }
}
data "template_file" "k8s_worker1_metadata" {
  template = file("meta-data-ubuntu.yml")
  vars = {
    HOSTNAME = "k8s-worker1"
  }
}
data "template_file" "k8s_worker2_metadata" {
  template = file("meta-data-ubuntu.yml")
  vars = {
    HOSTNAME = "k8s-worker2"
  }
}

resource "esxi_guest" "k8s-master1" {
  guest_name     = "k8s-master1"
  power          = "on"
  disk_store     = var.DISK_STORE
  clone_from_vm  = "template-ubuntu2004"
  memsize        = "4096"
  numvcpus       = "2"
  boot_disk_size = "30"
  network_interfaces {
    virtual_network = esxi_portgroup.portgroup100_1.name
    mac_address     = "00:50:56:00:64:04"
  }
  network_interfaces {
    virtual_network = esxi_portgroup.portgroup101_1.name
    mac_address     = "00:50:56:00:65:04"
  }
  guestinfo = {
    "metadata.encoding" = "gzip+base64"
    "metadata"          = base64gzip(data.template_file.k8s_master1_metadata.rendered)
    "userdata.encoding" = "gzip+base64"
    "userdata"          = base64gzip(data.template_file.k8s_master1_userdata.rendered)
  }
}
resource "esxi_guest" "k8s-worker1" {
  guest_name     = "k8s-worker1"
  power          = "on"
  disk_store     = var.DISK_STORE
  clone_from_vm  = "template-ubuntu2004"
  memsize        = "4096"
  numvcpus       = "2"
  boot_disk_size = "30"
  network_interfaces {
    virtual_network = esxi_portgroup.portgroup100_1.name
    mac_address     = "00:50:56:00:64:05"
  }
  network_interfaces {
    virtual_network = esxi_portgroup.portgroup101_1.name
    mac_address     = "00:50:56:00:65:05"
  }
  guestinfo = {
    "metadata.encoding" = "gzip+base64"
    "metadata"          = base64gzip(data.template_file.k8s_worker1_metadata.rendered)
    "userdata.encoding" = "gzip+base64"
    "userdata"          = base64gzip(data.template_file.k8s_worker1_userdata.rendered)
  }
}
resource "esxi_guest" "k8s-worker2" {
  guest_name     = "k8s-worker2"
  power          = "on"
  disk_store     = var.DISK_STORE
  clone_from_vm  = "template-ubuntu2004"
  memsize        = "4096"
  numvcpus       = "2"
  boot_disk_size = "30"
  network_interfaces {
    virtual_network = esxi_portgroup.portgroup100_1.name
    mac_address     = "00:50:56:00:64:06"
  }
  network_interfaces {
    virtual_network = esxi_portgroup.portgroup101_1.name
    mac_address     = "00:50:56:00:65:06"
  }
  guestinfo = {
    "metadata.encoding" = "gzip+base64"
    "metadata"          = base64gzip(data.template_file.k8s_worker2_metadata.rendered)
    "userdata.encoding" = "gzip+base64"
    "userdata"          = base64gzip(data.template_file.k8s_worker2_userdata.rendered)
  }
}
