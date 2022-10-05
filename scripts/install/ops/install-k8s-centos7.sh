#!/usr/bin/env bash

## install Docker CE in advance

## DO NOT install etcd in advance

## install kubeadm
# ./install-kubeadm-centos7.sh


## disable and stop firewall and SELinux
#sudo systemctl disable firewalld
#sudo systemctl stop firewalld

## turn off SWAP
sudo swapoff -a
## comment swap line from /etc/fstab


## if preflight complains on /proc/sys/net/bridge/bridge-nf-call-iptables
#echo '1' | sudo tee /proc/sys/net/bridge/bridge-nf-call-iptables
##FIXME will be reset after restart mahcine

sudo kubeadm config images -v 9 pull

sudo kubeadm init -v 9 --config=init-config.yaml


#sudo systemctl enable kubelet


mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config


## https://kubernetes.io/docs/concepts/cluster-administration/addons/
#kubectl apply -f [podnetwork].yaml
kubectl apply -f "https://cloud.weave.works/k8s/net?k8s-version=$(kubectl version | base64 | tr -d '\n')"
