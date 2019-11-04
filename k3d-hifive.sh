#!/usr/bin/env sh

# Allow developer to set their own location if they wish
HIGHFIVE_LOCAL_VALUES="${HIGHFIVE_LOCAL_VALUES:-hifive/local-values.yaml}"

if ! test -f "$HIGHFIVE_LOCAL_VALUES" ; then
  echo "You must provide local values/secrets for the High Five helm chart, such as:"
  echo "    LDAP, Email, Authentication, Database command(s) "
  exit 1
fi

echo "cluster: creating hifive k3s cluster"
k3d create -n hifive --workers 1 --wait 0
echo "k3s: setting up kubeconfig"
export KUBECONFIG="$(k3d get-kubeconfig --name='hifive')"

echo "tiller: creating service account"
kubectl -n kube-system create serviceaccount tiller
echo "tiller: setting up rbac for service account"
kubectl create clusterrolebinding tiller --clusterrole cluster-admin --serviceaccount=kube-system:tiller

echo "helm: initializing with tiller service account"
helm init --service-account tiller --wait

echo "helm: installing High Five!"

helm install --name hifive ./hifive
helm install --name hifive -f hifive/values.yaml -f "$HIGHFIVE_LOCAL_VALUES" ./hifive


