terraform {
  required_providers {
    esxi = {
      source  = "josenk/esxi"
      version = "1.10.2"
    }
    remote = {
      source  = "tenstad/remote"
      version = "0.0.23"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.11.0"
    }
    kustomization = {
      source  = "kbst/kustomization"
      version = "0.9.0"
    }
  }
  backend "remote" {
    organization = "yumenomatayume"
    workspaces {
      name = "home"
    }
  }
}
