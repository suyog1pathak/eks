# Infra creation with terraform <img src="https://s3-ap-southeast-2.amazonaws.com/content-prod-529546285894/2020/03/tf.png" width="30px">

* These terraform modules will create and deploy infra on AWS necessary for eks.


Module          | details
------------- | -------------
vpc  | This module will create vpc, subnet, dhcp option set, route table, S3 vpc endpoint etc with the provided information. All resources will be created with appropriate tags. 
securityGroups  | This module creates security groups with default inbound policy i.e. all-traffic from VPC cidr
eksIamRole| This module will create IAM roles provided which is further required in the creation of IAM service accounts.
rds| This module will provision aws rds cluster with provided number of instances.
elasticache | This module will provision elasticache cluster. 
neptune | This module will provision neptune cluster. 
msk | This module will provision msk cluster.