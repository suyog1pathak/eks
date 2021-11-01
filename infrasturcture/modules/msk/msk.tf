
# resource "aws_elasticache_replication_group" "ecRg" {
#   automatic_failover_enabled    = true
#   availability_zones            = lookup(var.data, "availability_zones")
#   replication_group_id          = format("%s-%s-%s",lookup(var.data, "name"),lookup(var.tags, "product"),lookup(var.tags, "env"))
#   replication_group_description = format("%s-%s-%s",lookup(var.data, "name"),lookup(var.tags, "product"),lookup(var.tags, "env"))
#   node_type                     = lookup(var.data, "node_type")
#   parameter_group_name          = lookup(var.data, "parameter_group_name")
#   port                          = 6379
#   subnet_group_name             = aws_elasticache_subnet_group.ecSubnetGroup.name
#   engine         = lookup(var.data, "engine")
#   engine_version = lookup(var.data, "engine_version")
#   multi_az_enabled  = lookup(var.data, "multi_az_enabled")
#   maintenance_window =  lookup(var.data, "maintenance_window")
#   apply_immediately = lookup(var.data, "apply_immediately")
#   security_group_ids = [aws_security_group.ecSg.id] 

#   cluster_mode {
#     replicas_per_node_group = lookup(var.data, "replicas_per_node_group")
#     num_node_groups         = lookup(var.data, "num_node_groups")
#   }

#   tags  = merge(
#    {
#      "Name": format("%s-%s-%s",lookup(var.data, "name"),lookup(var.tags, "product"),lookup(var.tags, "env"))
#    },
#    var.tags
#   )

# }

resource "aws_msk_configuration" "msk" {
  kafka_versions = [lookup(var.data, "kafka_version")]
  name           = format("%s-%s-%s",lookup(var.data, "name"),lookup(var.tags, "product"),lookup(var.tags, "env"))

  server_properties = lookup(var.data, "config")
}




resource "aws_msk_cluster" "msk" {
  cluster_name           = format("%s-%s-%s",lookup(var.data, "name"),lookup(var.tags, "product"),lookup(var.tags, "env"))
  kafka_version          = lookup(var.data, "kafka_version")
  number_of_broker_nodes = lookup(var.data, "number_of_broker_nodes")

  broker_node_group_info {
    instance_type   = lookup(var.data, "instance_type")
    ebs_volume_size = lookup(var.data, "ebs_volume_size")
    client_subnets = var.dbSubnets
    security_groups = [aws_security_group.msk.id]
  }

  encryption_info {
    encryption_in_transit {
      client_broker = "TLS_PLAINTEXT"
    }
  }

  configuration_info {
    arn = aws_msk_configuration.msk.arn
    revision = 1
  }  

  tags        = merge(
   {
     "Name": format("%s-%s-%s",lookup(var.data, "name"),lookup(var.tags, "product"),lookup(var.tags, "env"))
   },
   var.tags
  )
}

