resource "aws_db_parameter_group" "dbParameterGroup" {
  name   = format("%s-%s-%s-%s",lookup(var.data, "name"),lookup(var.tags, "product"),lookup(var.tags, "env"),"db-parametergroup")
  family = lookup(var.data, "family")
  

  count = length(var.data.dbParameterGroup)
  parameter {
    name  = lookup(var.data.dbParameterGroup[count.index], "name")
    value = lookup(var.data.dbParameterGroup[count.index], "value")
    apply_method = "pending-reboot"
  }

  tags        = merge(
   {
     "Name": format("%s-%s-%s-%s",lookup(var.data, "name"),lookup(var.tags, "product"),lookup(var.tags, "env"),"db-parametergroup")
   },
   var.tags
  )

}


resource "aws_rds_cluster_parameter_group" "clusterParameterGroup" {
  name   = format("%s-%s-%s-%s",lookup(var.data, "name"),lookup(var.tags, "product"),lookup(var.tags, "env"),"cluster-parametergroup")
  family = lookup(var.data, "family")

  count = length(var.data.clusterParameterGroup)
  parameter {
    name  = lookup(var.data.clusterParameterGroup[count.index], "name")
    value = lookup(var.data.clusterParameterGroup[count.index], "value")
    apply_method = "pending-reboot"
  }

  tags        = merge(
   {
     "Name": format("%s-%s-%s-%s",lookup(var.data, "name"),lookup(var.tags, "product"),lookup(var.tags, "env"),"cluster-parametergroup")
   },
   var.tags
  )
}