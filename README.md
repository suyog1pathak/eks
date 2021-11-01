# EKS Cluster deployment and bootstraping! <img src="https://raw.githubusercontent.com/MartinHeinz/MartinHeinz/master/wave.gif" width="30px">

* This repo consists of all automation required to deploy eks cluster with all pre-requisites. Furthermore, this repo can be divided into few modules as below.

Module| purpose
---|---
Infrastructure| Deploys Amazon vpc with all provisions required for eks cluster.
Cluster creation| Creating eks cluster along with node groups and IAM service accounts.

- ***Infrastructure***

1] Create `values.tf` in `/values` of infrastructure directory which consists of terraform custom modules.

2] update `backend.tf` with S3 bucket name.
```
terraform {
  backend "s3" {
    bucket = ""
    key    = ""
    region = ""
  }
}
```

3] update `provider.tf` with aws region.
```
provider "aws" {
  region 	= "ap-south-1"
}
```

***You can comment out RDS/elasticache/neptune/msk module block in `main.tf` if you are not planning to deploy.***

3] init and play
```
terraform init
terraform plan -var-file=./values/pinaka-staging.tfvars 
```
4] Deploy.
```
terraform deploy -var-file=./values/pinaka-staging.tfvars 
```
---
- ***Cluster creation***

1] Start ec2 instance as bastion host in newly created VPC.\
2] Assign IAM role with proper permissions. (admin or permission required for eks cluster creation) \
3] Place `deploy-me` directory with updated files.\
4] Update CLUSTER_NAME, ENVTAG, REGION, EC2ENDPOINT in `bootstrap.sh` and execute it as 
```
bash bootstrap.sh cluster.yml
```

This will create eks cluster along with IAM service accounts, worker groups etc.

---

- ***Cluster bootstrping***

1] Install argocd with helm. (https://github.com/suyog1pathak/helm-charts/tree/main/charts/argocd)
-    Clone repo on ec2. \
-    Execute below in `charts/argocd` directory. \
(Update command with github username and api token)
```
helm install argocd . --set gitUrl=https://github.com/svdf/pinaka-infra.git --set repoName=infra --set secret.username=USERNAME --set secret.password=API-TOKEN --namespace argocd 
```

2] Install all pre-requisites required for eks cluster as argocd applications. 

- Clone repo on ec2
- Execute the below command.
```
helm install argocd-apps .
```

***What will I get ?***EKS cluster/infrastructure with below.
features|
--|
Subnet with required tags for pod IP allocation and public/private bifurcation |
pre-configured security groups |
IAM policies and roles required for eks |
Single nat gateway for all private subnets (adding 3 nat gateway is under progress) |
vpc endpoint for S3, ecr.api, ecr.dkr |
Worker autoscaling group with tagging for cluster auto scaler |
pre-installed cilium as CNI |
pre-installed AWS alb ingress controller | 
pre-installed EBS storage controller | 
cilium local node DNS cache configured |
argocd installed and slack integration |
pre-installed cluster auto scaler |
pre-installed external DNS |
all apps with argocd application with gitops.

***Developer's contact:***
suyog1pathak@gmail.com