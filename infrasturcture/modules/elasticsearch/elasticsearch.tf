
resource "aws_elasticsearch_domain" "es" {
  domain_name           = lookup(var.data, "name")
  elasticsearch_version = lookup(var.data, "elasticsearch_version")

  cluster_config {
    instance_type = lookup(var.data, "data_node_instance_type")
    zone_awareness_enabled = true
  }
  master_user_name = lookup(var.data, "master_user_name")
  master_user_password = lookup(var.data, "master_user_password")
  dedicated_master_count = lookup(var.data, "dedicated_master_count")
  dedicated_master_enabled = lookup(var.data, "dedicated_master_enabled")
  dedicated_master_type = lookup(var.data, "dedicated_master_type")
  instance_count = lookup(var.data, "instance_count")
  instance_type = lookup(var.data, "instance_type")
  ebs_enabled = lookup(var.data, "ebs_enabled")
  volume_size = lookup(var.data, "volume_size")
  volume_type = lookup(var.data, "volume_type")


  vpc_options {
    subnet_ids = var.dbSubnets
    security_group_ids = [aws_security_group.ecSg.id]
  }

  tags = merge(
   {
     "Name": format("%s-%s-%s",lookup(var.data, "name"),lookup(var.tags, "product"),lookup(var.tags, "env"))
   },
   var.tags
  )
}