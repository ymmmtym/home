resource "esxi_vswitch" "vswitch1" {
  name = "vSwitch1"
}

resource "esxi_portgroup" "portgroup100_1" {
  name    = "vSwitch1 PortGroup100"
  vswitch = esxi_vswitch.vswitch1.name
  vlan    = 100
}

resource "esxi_portgroup" "portgroup101_1" {
  name    = "vSwitch1 PortGroup101"
  vswitch = esxi_vswitch.vswitch1.name
  vlan    = 101
}
