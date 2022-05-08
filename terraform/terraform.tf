terraform {
  required_providers {
    esxi = {
      source  = "josenk/esxi"
      version = "1.10.2"
    }
    remote = {
      source = "tenstad/remote"
      version = "0.0.23"
    }
    kubernetes = {
      source = "hashicorp/kubernetes"
      version = "2.11.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "2.5.1"
    }
  }
  backend "remote" {
    organization = "yumenomatayume"
    workspaces {
      name = "home"
    }
  }
}
