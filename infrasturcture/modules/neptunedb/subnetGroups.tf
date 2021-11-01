resource "aws_neptune_subnet_group" "neptuneSubnetGroup" {
  name       = format("%s-%s-%s-%s",lookup(var.data, "name"),lookup(var.tags, "product"),lookup(var.tags, "env"),"neptune-subnetgroup")
  subnet_ids = var.dbSubnets

  tags        = merge(
   {
     "Name": format("%s-%s-%s-%s",lookup(var.data, "name"),lookup(var.tags, "product"),lookup(var.tags, "env"),"neptune-subnetgroup")
   },
   var.tags
  )
}