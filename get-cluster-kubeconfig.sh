#!/usr/bin/env bash

set -eux

REPO_ROOT=$(realpath "$(dirname "${BASH_SOURCE[0]}")")

rm -rf "${REPO_ROOT}/Karmada/data" "${REPO_ROOT}/Karmada/pki"
mkdir -p "${REPO_ROOT}/Karmada/data"
mkdir -p "${REPO_ROOT}/Karmada/pki"

kubectl config use-context kind-kind
karmadactl init --karmada-data="${REPO_ROOT}/Karmada/data" --karmada-pki="${REPO_ROOT}/Karmada/pki"

KARMADA_KUBECONFIG="${REPO_ROOT}/Karmada/data/karmada-apiserver.config"

kubectl config use-context minikube
for i in $(seq 1 5); do
	clusterctl get kubeconfig kamaji-${i} > "${REPO_ROOT}/kamaji-${i}.kubeconfig"
done
# export KUBECONFIG="${kubeconfig}"
# kubectl config view --flatten > "${REPO_ROOT}/karmada.kubeconfig"


kubectl config use-context kind-kind
for i in $(seq 1 5); do
	# karmadactl --kubeconfig "${KARMADA_KUBECONFIG}" join "kamaji-${i}" --cluster-kubeconfig="${HOME}/.kube/config" --cluster-context="kubernetes-admin@kamaji-${i}"
	karmadactl --kubeconfig "${KARMADA_KUBECONFIG}" join "kamaji-${i}" --cluster-kubeconfig="${REPO_ROOT}/kamaji-${i}.kubeconfig"
done
