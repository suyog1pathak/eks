vpc_vars = {
  "name" = "pinaka"
  "cidr_block" = "10.21.0.0/16"
  "region" = "ap-south-1"
  "subnet_public" = [
    {
        "subnet_name": "pinaka-uat-public-1a"
        "az": "ap-south-1a"
        "cidr": "10.21.0.0/20"
        "public": true
    },
    {
        "subnet_name": "pinaka-uat-public-1b"
        "az": "ap-south-1b"
        "cidr": "10.21.16.0/20"
        "public": true
    },
    {
        "subnet_name": "pinaka-uat-public-1c"
        "az": "ap-south-1c"
        "cidr": "10.21.32.0/20"
        "public": true
    }         
  ]
  "subnet_private" = [
    {
        "subnet_name": "pinaka-uat-private-1a"
        "az": "ap-south-1a"
        "cidr": "10.21.64.0/18"
        "public": false
    },
    {
        "subnet_name": "pinaka-uat-private-1b"
        "az": "ap-south-1b"
        "cidr": "10.21.128.0/18"
        "public": false
    },
    {
        "subnet_name": "pinaka-uat-private-1c"
        "az": "ap-south-1c"
        "cidr": "10.21.192.0/18"
        "public": false
    }               
  ]
  "subnet_private_db" = [
    {
        "subnet_name": "pinaka-uat-db-1a"
        "az": "ap-south-1a"
        "cidr": "10.21.48.0/21"
        "public": false
    },
    {
        "subnet_name": "pinaka-uat-db-1b"
        "az": "ap-south-1b"
        "cidr": "10.21.56.0/22"
        "public": false
    },
    {
        "subnet_name": "pinaka-uat-db-1c"
        "az": "ap-south-1c"
        "cidr": "10.21.60.0/22"
        "public": false
    }               
  ]
}

route_tables_public = [
  {
    "name": "pinaka-uat-public-rt"
    "public": true
  }
]

route_tables_private = [
  {
    "name": "pinaka-uat-private-rt"
    "public": false
  }
]

route_tables_private_db = [
  {
    "name": "pinaka-uat-private-db-rt"
    "public": false
  }
]

default_tags = {
    "env" = "uat"
    "product" = "pinaka"
    "managed_by" = "terraform"
    "billing_center" = "pinaka"
    "random" = "cs23"
}

security_groups = [
  "ec2-bastion",
  "eks-cluster",
  "cache",
  "rds",
  "elasticsearch"
]


rds_data = [
  {
    "availability_zones" = ["ap-south-1a", "ap-south-1b", "ap-south-1c"]
    "name" = "pinaka",
    "family" = "aurora-postgresql13"
    "master_username" = "sadmin"
    "master_password" = ""
    "backup_retention_period" = "7"
    "engine_version" = "13.3"
    "engine" = "aurora-postgresql"
    "preferred_backup_window" = "07:00-08:00"
    "backup_retention_period" = "8"
    "preferred_maintenance_window" = "wed:04:00-wed:04:30"
    "instanceCount" = "2"
    "instance_class" = "db.t3.medium"
    "auto_minor_version_upgrade" = "false"
    "dbParameterGroup" = [
      {
        "name" = "max_connections"
        "value" = "500"
      }
    ]
    "clusterParameterGroup" = [
      {
        "name" = "max_connections"
        "value" = "500"
      }
    ]    
  }
]

neptune_data = [
  {
    "availability_zones" = ["ap-south-1a", "ap-south-1b", "ap-south-1c"]
    "name" = "pinaka",
    "family" = "neptune1"
    "backup_retention_period" = "7"
    "engine_version" = "1.0.5.1"
    "engine" = "neptune"
    "preferred_backup_window" = "07:00-08:00"
    "backup_retention_period" = "4"
    "preferred_maintenance_window" = "wed:04:00-wed:04:30"
    "instanceCount" = "2"
    "instance_class" = "db.t3.medium"
    "dbParameterGroup" = [
      {
        "name" = "neptune_query_timeout"
        "value" = "120000"
      }
    ]
    "clusterParameterGroup" = [
      {
        "name" = "neptune_enable_audit_log"
        "value" = "0"
      }
    ]    
  }
]

elasticache_data = [
  {
   "name" = "pinaka",
   "availability_zones" = ["ap-south-1a", "ap-south-1b", "ap-south-1c"],
   "engine" = "redis",
   "node_type" = "cache.t3.small",
   "engine_version" = "6.x",
   "maintenance_window" = "sun:08:00-sun:09:00"
   "parameter_group_name" = "default.redis6.x.cluster.on"
   "num_node_groups" = "1",
   "replicas_per_node_group" = "2"
   "multi_az_enabled" = "true"
   "apply_immediately" = "true"
   "snapshot_retention_limit" = "7"
   "snapshot_window" = "05:00-06:00"
  }
]


msk_data = [
  {
   "name" = "pinaka",
   "kafka_version" = "2.8.0",
   "number_of_broker_nodes" = "3",
   "instance_type" = "kafka.t3.small",
   "ebs_volume_size" = "50"
   "config" = <<-EOT
auto.create.topics.enable=true
default.replication.factor=3
min.insync.replicas=2
num.io.threads=8
num.network.threads=5
num.partitions=1
num.replica.fetchers=2
replica.lag.time.max.ms=30000
socket.receive.buffer.bytes=102400
socket.request.max.bytes=104857600
socket.send.buffer.bytes=102400
unclean.leader.election.enable=true
zookeeper.session.timeout.ms=18000
    EOT
  }
]



# elasticsearch_data = [
#   {
#     "name" = "pinaka"
#     "elasticsearch_version" = "7.10"
#     "data_node_instance_type" = ""
#     "master_user_name" = ""
#     "master_user_password" = ""
#     "dedicated_master_count" = ""
#     "dedicated_master_enabled" = ""
#     "dedicated_master_type" = ""
#     "instance_count" = ""
#     "instance_type" = ""
#     "ebs_enabled" = ""
#     "volume_size" = ""
#     "volume_type" =  ""   
#   }
# ]