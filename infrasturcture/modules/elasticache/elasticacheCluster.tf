
resource "aws_elasticache_replication_group" "ecRg" {
  automatic_failover_enabled    = true
  availability_zones            = lookup(var.data, "availability_zones")
  replication_group_id          = format("%s-%s-%s",lookup(var.data, "name"),lookup(var.tags, "product"),lookup(var.tags, "env"))
  replication_group_description = format("%s-%s-%s",lookup(var.data, "name"),lookup(var.tags, "product"),lookup(var.tags, "env"))
  node_type                     = lookup(var.data, "node_type")
  parameter_group_name          = lookup(var.data, "parameter_group_name")
  port                          = 6379
  subnet_group_name             = aws_elasticache_subnet_group.ecSubnetGroup.name
  engine         = lookup(var.data, "engine")
  engine_version = lookup(var.data, "engine_version")
  multi_az_enabled  = lookup(var.data, "multi_az_enabled")
  maintenance_window =  lookup(var.data, "maintenance_window")
  apply_immediately = lookup(var.data, "apply_immediately")
  security_group_ids = [aws_security_group.ecSg.id]
  snapshot_window = lookup(var.data, "snapshot_window")
  # snapshot_retention_limit = lookup(var.data, "snapshot_retention_limit")

  cluster_mode {
    replicas_per_node_group = lookup(var.data, "replicas_per_node_group")
    num_node_groups         = lookup(var.data, "num_node_groups")
  }

  tags  = merge(
   {
     "Name": format("%s-%s-%s",lookup(var.data, "name"),lookup(var.tags, "product"),lookup(var.tags, "env"))
   },
   var.tags
  )

}