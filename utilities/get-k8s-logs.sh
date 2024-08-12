#!/usr/bin/env bash

get_pod_name_with_prefix() {
	prefix=${1:?}
	namespace=${2:-"default"}
	pods=($(kubectl -n "${namespace}" get pods -o jsonpath="{.items[*].metadata.name}"))
	for pod in "${pods[@]}"; do
		if [[ "${pod}" == "${prefix}"* ]]; then
			echo "${pod}"
		fi
	done
}

get_pod_containers() {
	pod_name=${1:?}
	namespace=${2:-"default"}
	containers=$(kubectl -n "${namespace}" get pods "${pod_name}" -o jsonpath="{.spec['containers','initContainers'][*].name}")
	echo $containers
}

get_ironic_logs() {
	pod_prefix=${1:-"baremetal-operator-ironic"}
	ns=${2:-"baremetal-operator-system"}
	log_dir="ironic-logs"
	rm -rf "${log_dir}"
	mkdir -p "${log_dir}"
	ironic_pod=$(get_pod_name_with_prefix "${pod_prefix}" "${ns}")
	echo "Ironic pod name: ${ironic_pod}"
	containers=($(get_pod_containers "${ironic_pod}" "${ns}"))
	for container in "${containers[@]}"; do
		echo "Getting logs from container ${container}"
		kubectl -n "${ns}" logs "${ironic_pod}" -c "${container}" | tee "${log_dir}/${container}.txt"
	done
}

get_ironic_logs
