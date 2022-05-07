terraform {
  required_providers {
    esxi = {
      source  = "josenk/esxi"
      version = "1.10.2"
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
