resource "aws_rds_cluster" "rdsCluster" {
  cluster_identifier      = format("%s-%s-%s",lookup(var.data, "name"),lookup(var.tags, "product"),lookup(var.tags, "env"))
  db_subnet_group_name    = aws_db_subnet_group.rdsSubnetGroup.name
  master_username         = lookup(var.data, "master_username")
  master_password         = lookup(var.data, "master_password")
  backup_retention_period = lookup(var.data, "backup_retention_period")
  preferred_backup_window = lookup(var.data, "preferred_backup_window")
  availability_zones      = lookup(var.data, "availability_zones")
  engine = lookup(var.data, "engine")
  copy_tags_to_snapshot = true
  engine_version = lookup(var.data, "engine_version")
  preferred_maintenance_window = lookup(var.data, "preferred_maintenance_window")
  db_cluster_parameter_group_name = aws_rds_cluster_parameter_group.clusterParameterGroup[0].name
  skip_final_snapshot  = true
  vpc_security_group_ids = [aws_security_group.rdsSg.id]
  tags  = merge(
   {
     "Name": format("%s-%s-%s",lookup(var.data, "name"),lookup(var.tags, "product"),lookup(var.tags, "env"))
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


resource "aws_rds_cluster_instance" "default" {
  count                           = lookup(var.data, "instanceCount")
  identifier                      = format("%s-%s-%s-%s-%d",lookup(var.data, "name"),lookup(var.tags, "product"),lookup(var.tags, "env"), "instance", count.index)
  cluster_identifier              = aws_rds_cluster.rdsCluster.id
  instance_class                  = lookup(var.data, "instance_class")
  db_subnet_group_name            = aws_db_subnet_group.rdsSubnetGroup.name
  db_parameter_group_name         = aws_db_parameter_group.dbParameterGroup[0].name

  engine                          = lookup(var.data, "engine")
  engine_version                  = lookup(var.data, "engine_version")
  auto_minor_version_upgrade      = lookup(var.data, "auto_minor_version_upgrade")
  monitoring_interval             = 0
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
     "Name": format("%s-%s-%s-%s-%d",lookup(var.data, "name"),lookup(var.tags, "product"),lookup(var.tags, "env"), "instance", count.index)
   },
   var.tags
  )


}