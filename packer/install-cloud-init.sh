#!/usr/bin/env bash

install-pip() {
  case "$1" in
    7)
      yum install -y epel-release
      yum install -y python-pip --enablerepo=epel
      ;;
    8) yum install -y python3 ;;
  esac
}

install() {
  case "$1" in
    centos)
      yum install -y open-vm-tools
      install-pip "$2"
      yum install -y cloud-init
      ;;
    ubuntu)
      apt install -y open-vm-tools
      apt install -y python3-pip
      apt install -y cloud-init
      ;;
  esac
  curl https://raw.githubusercontent.com/vmware/cloud-init-vmware-guestinfo/master/install.sh | sh -
  cloud-init clean
}


if [[ -f /etc/os-release ]]; then
  source /usr/lib/os-release
else
  echo "/etc/os-release is not exist."
  exit 1
fi

install "$ID" "$VERSION_ID"