#!/bin/bash

ibmcloud ks cluster config --cluster bnimkjfd093mlbf6d960

export KUBECONFIG=/home/jjasghar/.bluemix/plugins/container-service/clusters/bnimkjfd093mlbf6d960/kube-config-dal10-k8s.asgharlabs.io.yml

WATCHER=$(kubectl get pods | grep 'watcher-out' | awk {'print $1'})

kubectl logs ${WATCHER} -f
