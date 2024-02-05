#!/bin/bash
#
# ns="baremetal-operator-system"
ns="capm3-system"
podnames=$(kubectl -n ${ns} get pods -o json | jq -r '.items[].metadata.name' | grep "capm3")
rm -f camp3-logs.txt
kubectl -n $ns logs $podnames > capm3-logs.txt
