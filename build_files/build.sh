#!/bin/bash

set -ouex pipefail

### Install packages
dnf install -y sudo \
    NetworkManager \
    firewalld \
    container-selinux \
    selinux-policy-base \
    https://rpm.rancher.io/k3s/latest/common/centos/9/noarch/k3s-selinux-1.6-1.el9.noarch.rpm

### Install K3s 
curl -sfL https://get.k3s.io | INSTALL_K3S_SKIP_ENABLE="true" \
    INSTALL_K3S_SKIP_START="true" \
    INSTALL_K3S_CHANNEL="stable" \
    INSTALL_K3S_SKIP_SELINUX_RPM="true" \
    INSTALL_K3S_BIN_DIR="/usr/local/sbin" sh -

### Configure firewall rules
firewall-offline-cmd --add-port=6443/tcp #apiserver
firewall-offline-cmd --zone=trusted --add-source=10.42.0.0/16 #pods
firewall-offline-cmd --zone=trusted --add-source=10.43.0.0/16 #services
firewall-offline-cmd --set-default-zone=trusted