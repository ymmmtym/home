# -*- mode: ruby -*-
# vi: set ft=ruby :

nodes = {
  "template-centos7"    => ["generic/centos7",     1, 1024, 10, '00:50:56:00:00:31' ],
  "template-centos8"    => ["generic/centos8",     1, 1024, 10, '00:50:56:00:00:32' ],
  "template-ubuntu2004" => ["generic/ubuntu2004",  1, 1024, 10, '00:50:56:00:00:33' ],
}

Vagrant.configure(2) do |config|
  nodes.each do | (name, cfg) |
    box, numvcpus, memory, storage, macaddr = cfg
    config.vm.define name do |machine|
      machine.vm.box   = box
      machine.vm.hostname = name
      machine.vm.provider :vmware_esxi do |esxi|
        esxi.esxi_hostname         = '192.168.0.2'
        esxi.esxi_username         = 'root'
        esxi.esxi_password         = 'env:ESXI_ROOTPASSWORD'
        esxi.esxi_virtual_network  = "VM Network"
        esxi.guest_numvcpus        = numvcpus
        esxi.guest_memsize         = memory
        esxi.guest_storage         = storage
        esxi.guest_mac_address     = macaddr
        esxi.local_allow_overwrite = 'True'
      end
    end
  end
end
