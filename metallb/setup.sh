#!/bin/env bash

minikube start --driver=kvm2 --kubernetes-version=v1.24.0 \
  --cni=calico \
  --extra-config=kubelet.node-ip=192.168.49.2,fd00:10:244::2 \
  --extra-config=apiserver.service-cluster-ip-range=10.244.0.0/16,fd00:10:244::/64 \
  --extra-config=controller-manager.cluster-cidr=10.244.0.0/16,fd00:10:244::/64 \
  --extra-config=controller-manager.service-cluster-ip-range=10.96.0.0/12,fd00:10:96::/112 \
  --extra-config=kube-proxy.cluster-cidr=10.244.0.0/16,fd00:10:244::/64 \
  --extra-config=kubelet.cgroup-driver=systemd \
  --cpus=4 --memory=8192

# Install metallb with helm
helm repo add metallb https://metallb.github.io/metallb
kubectl create ns metallb-system
helm install metallb metallb/metallb --version v0.14.5 --namespace metallb-system

sleep 30

kubectl apply -f configmap.yaml

kubectl create deploy nginx --image nginx
