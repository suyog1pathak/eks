resource "aws_elasticache_subnet_group" "ecSubnetGroup" {
  name       = format("%s-%s-%s-%s",lookup(var.data, "name"),lookup(var.tags, "product"),lookup(var.tags, "env"),"subnetgroup")
  subnet_ids = var.dbSubnets

  tags        = merge(
   {
     "Name": format("%s-%s-%s-%s",lookup(var.data, "name"),lookup(var.tags, "product"),lookup(var.tags, "env"),"subnetgroup")
   },
   var.tags
  )
}