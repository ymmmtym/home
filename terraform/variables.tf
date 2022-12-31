variable "ESXI_HOSTNAME" { default = "esxi" }
variable "ESXI_HOSTPORT" { default = "22" }
variable "ESXI_HOSTSSL" { default = "443" }
variable "ESXI_USERNAME" { default = "root" }
variable "ESXI_PASSWORD" {}
variable "DISK_STORE" { default = "datastore1" }
variable "VIRTUAL_NETWORK" { default = "VM Network" }
variable "helm_path" { default = "/usr/local/bin/helm" }
variable "vault_token" {}
