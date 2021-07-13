resource "esxi_guest" "vyos01" {
  guest_name     = "vyos01"
  power          = "on"
  disk_store     = var.DISK_STORE
  clone_from_vm  = "template-vyos"
  memsize        = "1024"
  numvcpus       = "1"
  boot_disk_size = "10"
  network_interfaces {
    virtual_network = var.VIRTUAL_NETWORK
    mac_address     = "00:50:56:00:00:21"
  }
  network_interfaces {
    virtual_network = esxi_portgroup.portgroup100_1.name
    mac_address     = "00:50:56:00:64:01"
  }
  network_interfaces {
    virtual_network = esxi_portgroup.portgroup101_1.name
    mac_address     = "00:50:56:00:65:01"
  }
  provisioner "local-exec" {
    working_dir = ".."
    command = "ansible-playbook site.yml -l ${self.guest_name} -e ansible_host=${self.ip_address}"
  }
}

resource "esxi_guest" "vyos02" {
  guest_name     = "vyos02"
  power          = "on"
  disk_store     = var.DISK_STORE
  clone_from_vm  = "template-vyos"
  memsize        = "1024"
  numvcpus       = "1"
  boot_disk_size = "10"
  network_interfaces {
    virtual_network = var.VIRTUAL_NETWORK
    mac_address     = "00:50:56:00:00:22"
  }
  network_interfaces {
    virtual_network = esxi_portgroup.portgroup100_1.name
    mac_address     = "00:50:56:00:64:02"
  }
  network_interfaces {
    virtual_network = esxi_portgroup.portgroup101_1.name
    mac_address     = "00:50:56:00:65:02"
  }
  provisioner "local-exec" {
    working_dir = ".."
    command = "ansible-playbook site.yml -l ${self.guest_name} -e ansible_host=${self.ip_address}"
  }
}
