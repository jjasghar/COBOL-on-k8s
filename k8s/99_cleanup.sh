#!/bin/bash

source ../local.env

KUBECONFIG=""

eval $(ibmcloud ks cluster config $CLUSTER_NAME | grep export)

kubectl delete deployment --all
kubectl delete pod --all
kubectl delete svc --all
kubectl delete pvc --all
