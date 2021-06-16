variable "ESXI_HOSTNAME" { default = "esxi" }
variable "ESXI_HOSTPORT" { default = "22" }
variable "ESXI_HOSTSSL" { default = "443" }
variable "ESXI_USERNAME" { default = "root" }
variable "ESXI_PASSWORD" {}
variable "DISK_STORE" { default = "datastore1" }
variable "VIRTUAL_NETWORK" { default = "VM Network" }
variable "OVF_SOURCE_UBUNTU_FOCAL" { default = "https://cloud-images.ubuntu.com/focal/current/focal-server-cloudimg-amd64.ova" }
variable "OVF_SOURCE_UBUNTU_BIONIC" { default = "https://cloud-images.ubuntu.com/bionic/current/bionic-server-cloudimg-amd64.ova" }
variable "OVF_SOURCE_UBUNTU_XENIAL" { default = "https://cloud-images.ubuntu.com/xenial/current/xenial-server-cloudimg-amd64.ova" }
variable "OVF_SOURCE_COREOS" { default = "https://mirror.openshift.com/pub/openshift-v4/dependencies/rhcos/latest/latest/rhcos-4.7.7-x86_64-vmware.x86_64.ova" }
variable "OVF_SOURCE_AMAZON" { default = "https://cdn.amazonlinux.com/os-images/2017.12.0.20171212.2/vmware/amzn2-vmware_esx-2017.12.0.20171212.2-x86_64.xfs.gpt.ova" }
variable "OVF_SOURCE_VYOS" { default = "https://s3.amazonaws.com/s3-us.vyos.io/vyos-1.1.8-amd64.ova" }
