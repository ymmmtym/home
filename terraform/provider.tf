terraform {
  required_providers {
    esxi = {
      source = "josenk/esxi"
      version = "1.8.1"
    }
  }
}

provider "esxi" {
  esxi_hostname      = var.ESXI_HOSTNAME
  esxi_hostport      = var.ESXI_HOSTPORT
  esxi_hostssl       = var.ESXI_HOSTSSL
  esxi_username      = var.ESXI_USERNAME
  esxi_password      = var.ESXI_PASSWORD
}