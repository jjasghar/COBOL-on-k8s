#!/bin/bash

source ../local.env

if ! [ -x "$(command -v s3fs)" ]; then
  echo 'Error: s3fs is not installed, or not in path.' >&2
  exit 1
fi

mounts3(){
  cd ../
  s3fs ${COS_ACCOUNT_BUCKET} ${S3_LOCAL_DIR}/ -o url=${S3_URL} -o passwd_file=${S3_KEY}
  cd k8s/
}

KUBECONFIG=""

eval $(ibmcloud ks cluster config $CLUSTER_NAME | grep export)

kubectl apply -f volume.yaml

VOLUME_STATUS=$(kubectl get pvc | grep "k8s-cobol" | awk {'print $2'})

while [ "${VOLUME_STATUS}" != "Bound" ]; do
  echo -n "."
  sleep 5
  VOLUME_STATUS=$(kubectl get pvc | grep "k8s-cobol" | awk {'print $2'})
done

kubectl apply -f fedora.yaml

sleep 5

WORKHORSE=$(kubectl get pods | grep workhorse | awk {'print $1'})

kubectl exec ${WORKHORSE} bash ./setup.sh

kubectl apply -f watcher-in.yaml

kubectl apply -f watcher-out.yaml

kubectl apply -f cobol_run.yaml
