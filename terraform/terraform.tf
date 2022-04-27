terraform {
  required_providers {
    esxi = {
      source  = "josenk/esxi"
      version = "1.8.1"
    }
    rke = {
      source  = "rancher/rke"
      version = "1.2.4"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.11.0"
    }
  }
  backend "remote" {
    organization = "yumenomatayume"
    workspaces {
      name = "home"
    }
  }
}
