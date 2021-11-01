resource "aws_neptune_cluster" "neptuneCluster" {
  cluster_identifier      = format("%s-%s-%s-%s",lookup(var.data, "name"),lookup(var.tags, "product"),lookup(var.tags, "env"),"neptunedb")
  neptune_subnet_group_name = aws_neptune_subnet_group.neptuneSubnetGroup.name
  backup_retention_period = lookup(var.data, "backup_retention_period")
  preferred_backup_window = lookup(var.data, "preferred_backup_window")
  availability_zones      = lookup(var.data, "availability_zones")
  engine = lookup(var.data, "engine")
  copy_tags_to_snapshot = true
  engine_version = lookup(var.data, "engine_version")
  preferred_maintenance_window = lookup(var.data, "preferred_maintenance_window")
  neptune_cluster_parameter_group_name = aws_neptune_cluster_parameter_group.clusterParameterGroup[0].name
  skip_final_snapshot  = true
  vpc_security_group_ids = [aws_security_group.neptuneSg.id]
  tags  = merge(
   {
     "Name": format("%s-%s-%s-%s",lookup(var.data, "name"),lookup(var.tags, "product"),lookup(var.tags, "env"),"neptunedb")
   },
   var.tags
  ) 
  /* depends_on = [
    aws_rds_cluster_parameter_group.clusterParameterGroup,  
    aws_db_parameter_group.dbParameterGroup,
    aws_db_subnet_group.rdsSubnetGroup,
    aws_security_group.rdsSg,
  ]    */
}


resource "aws_neptune_cluster_instance" "neptuneInstance" {
  count                           = lookup(var.data, "instanceCount")
  identifier                      = format("%s-%s-%s-%s-%s-%d",lookup(var.data, "name"),lookup(var.tags, "product"),lookup(var.tags, "env"), "instance","neptunedb", count.index)
  cluster_identifier              = aws_neptune_cluster.neptuneCluster.id
  instance_class                  = lookup(var.data, "instance_class")
  neptune_subnet_group_name       = aws_neptune_subnet_group.neptuneSubnetGroup.name
  neptune_parameter_group_name    = aws_neptune_parameter_group.dbParameterGroup[0].name

  engine                          = lookup(var.data, "engine")
  engine_version                  = lookup(var.data, "engine_version")
  preferred_maintenance_window    = lookup(var.data, "preferred_maintenance_window")

  /* depends_on = [
    aws_rds_cluster_parameter_group.clusterParameterGroup,  
    aws_db_parameter_group.dbParameterGroup,
    aws_db_subnet_group.rdsSubnetGroup,
    aws_security_group.rdsSg,
    aws_rds_cluster.rdsCluster
  ] */

  tags  = merge(
   {
     "Name": format("%s-%s-%s-%s-%s-%d",lookup(var.data, "name"),lookup(var.tags, "product"),lookup(var.tags, "env"), "instance","neptunedb", count.index)
   },
   var.tags
  )


}