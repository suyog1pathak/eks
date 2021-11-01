#!/bin/bash
CLUSTER_NAME="pinaka-uat"
ENVTAG="uat"
REGION="ap-south-1"
EC2ENDPOINT="https://ec2.ap-south-1.amazonaws.com"
# pre-requsites 
# 1] kubectl
# 2] helm
curl https://releases.hashicorp.com/terraform/0.14.5/terraform_0.14.5_linux_amd64.zip | gunzip - > ./terraform
mv ./terraform /bin && chmod a+x /bin/terraform
curl https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 | bash
mv /usr/local/bin/helm /bin/
cat <<EOF > /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
EOF
yum install -y kubectl git
curl --silent --location "https://github.com/weaveworks/eksctl/releases/download/0.61.0-rc.1/eksctl_Linux_amd64.tar.gz" | tar xz -C /tmp
mv /tmp/eksctl /bin/

# Create cluster without node group
eksctl create cluster -f ${1} 2>&1 | tee output1.log

# kubeconfig
aws eks --region ${REGION} update-kubeconfig --name ${CLUSTER_NAME}

# Delete existing vpc cni
kubectl -n kube-system delete daemonset aws-node

# Install cilium
# https://github.com/cilium/cilium/tree/v1.9.8/install/kubernetes/cilium
helm repo add cilium https://helm.cilium.io/
kubectl apply -f - <<EOF
---
apiVersion: v1
kind: ConfigMap
metadata:
  name: cilium-cni-configuration
  namespace: kube-system
data:
  cni-config: |
    {
      "cniVersion": "0.3.1",
      "name": "cilium",
      "type": "cilium-cni",
      "enable-debug": false,
      "eni": {
        "first-interface-index": 0,
        "subnet-tags": {
          "podsubnet": "true",
          "kubernetes.io/cluster/${CLUSTER_NAME}": "owned"
        }         
      }
    }
EOF
kubectl -n kube-system delete ds kube-proxy
kubectl -n kube-system delete cm kube-proxy
echo "APIendpoint for EKS Cluster api server ---:"
read APIENDPOINT
sleep 2
helm repo add cilium https://helm.cilium.io/
# helm install cilium cilium/cilium --version 1.9.8 --namespace kube-system --set eni=true --set ipam.mode=eni --set egressMasqueradeInterfaces=eth0 --set tunnel=disabled --set nodeinit.enabled=true --set kubeProxyReplacement=strict --set k8sServiceHost=${APIENDPOINT} --set k8sServicePort=443 --set cni.configMap=cilium-cni-configuration --set localRedirectPolicy=true

helm install cilium cilium/cilium --version 1.10.2 --namespace kube-system --set eni.enabled=true --set ipam.mode=eni --set tunnel=disabled --set nodeinit.enabled=true --set kubeProxyReplacement=strict --set cni.configMapKey=cilium-cni-configuration --set localRedirectPolicy=true --set eni.ec2APIEndpoint="${EC2ENDPOINT}" --set k8sServiceHost=${APIENDPOINT} --set k8sServicePort=443 --set eni.eniTags.env=${ENVTAG}

#
# helm upgrade cilium cilium/cilium --version 1.10.2 --namespace kube-system --set eni.enabled=true    --set ipam.mode=eni  --set tunnel=disabled  --set nodeinit.enabled=true --set kubeProxyReplacement=strict --set cni.configMapKey=cilium-cni-configuration --set localRedirectPolicy=true --set eni.ec2APIEndpoint="https://ec2.ap-south-1.amazonaws.com" --set k8sServiceHost= --set k8sServicePort=443
#
# --set cni.configMap=cilium-cni-configuration
#  https://github.com/cilium/cilium/issues/10426
#  --set k8sServiceHost=${APIENDPOINT} --set k8sServicePort=443
#  Kube proxy removal
#   --set eni=true \          # enabling this will deploy cilium as vpc cni
#  --set tunnel=disabled \    # 

wget https://raw.githubusercontent.com/cilium/cilium/v1.9/examples/kubernetes-local-redirect/node-local-dns.yaml
kubedns=$(kubectl get svc kube-dns -n kube-system -o jsonpath={.spec.clusterIP}) && sed -i "s/__PILLAR__DNS__SERVER__/$kubedns/g;" node-local-dns.yaml
kubectl apply -f node-local-dns.yaml
kubectl apply -f https://raw.githubusercontent.com/cilium/cilium/v1.9/examples/kubernetes-local-redirect/node-local-dns-lrp.yaml

# AWS ALB Controller
kubectl apply -k "github.com/aws/eks-charts/stable/aws-load-balancer-controller//crds?ref=master"
helm repo add eks https://aws.github.io/eks-charts
helm repo update
# --set hostNetwork=true
helm upgrade -i aws-load-balancer-controller eks/aws-load-balancer-controller --set clusterName=${CLUSTER_NAME} --set serviceAccount.create=false --set serviceAccount.name=aws-load-balancer-controller -n kube-system
kubectl create namespace argocd