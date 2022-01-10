locals {
  vyos = {
    numvcups       = 1
    memsize        = 1024
    boot_disk_size = 10
    nodes          = 2
  }
}

resource "esxi_guest" "vyos" {
  count          = local.vyos.nodes
  guest_name     = "vyos${format("%02d", count.index + 1)}"
  power          = "on"
  disk_store     = var.DISK_STORE
  clone_from_vm  = "template-vyos-rolling"
  memsize        = local.vyos.memsize
  numvcpus       = local.vyos.numvcups
  boot_disk_size = local.vyos.boot_disk_size
  network_interfaces {
    virtual_network = var.VIRTUAL_NETWORK
    mac_address     = "00:50:56:00:00:${format("%02X", count.index + 33)}"
  }
  network_interfaces {
    virtual_network = esxi_portgroup.portgroup100_1.name
    mac_address     = "00:50:56:00:64:${format("%02X", count.index + 1)}"
  }
  network_interfaces {
    virtual_network = esxi_portgroup.portgroup101_1.name
    mac_address     = "00:50:56:00:65:${format("%02X", count.index + 1)}"
  }
  provisioner "local-exec" {
    working_dir = ".."
    command     = "ansible-playbook site.yml -l ${self.guest_name} -e ansible_host=${self.ip_address} -v"
  }
}
