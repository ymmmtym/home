terraform {
  required_version = "~> 1.3.0"
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.11.0"
    }
    null = {
      source  = "hashicorp/null"
      version = "~> 3.1.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.1.0"
    }
    template = {
      source  = "hashicorp/template"
      version = "~> 2.2.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "~> 3.3.0"
    }
    esxi = {
      source  = "josenk/esxi"
      version = "~> 1.10.0"
    }
    kustomization = {
      source  = "kbst/kustomization"
      version = "~> 0.9.0"
    }
    remote = {
      source  = "tenstad/remote"
      version = "~> 0.0.0"
    }
  }
  backend "remote" {
    organization = "yumenomatayume"
    workspaces {
      name = "home"
    }
  }
}
