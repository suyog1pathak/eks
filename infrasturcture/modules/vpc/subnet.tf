# resource "aws_subnet" "subnet" {
#   count = length(var.subnet_private)
#   vpc_id     = aws_vpc.vpc.id
#   cidr_block = lookup(var.subnet_private[count.index], "cidr")
#   availability_zone = lookup(var.subnet_private[count.index], "az")
#   map_public_ip_on_launch = lookup(var.subnet_private[count.index], "public") ? true : false
#   tags = merge( 
#     {
#       "Name": lookup(var.subnet_private[count.index], "subnet_name"),
#       "is_public": lookup(var.subnet_private[count.index], "public") 
#      },
#       var.tags)
# }


resource "aws_subnet" "subnet_public" {
  count = length(var.subnet_public)
  vpc_id     = aws_vpc.vpc.id
  cidr_block = lookup(var.subnet_public[count.index], "cidr")
  availability_zone = lookup(var.subnet_public[count.index], "az")
  map_public_ip_on_launch = lookup(var.subnet_public[count.index], "public") ? true : false
  tags = merge( 
    {
      "Name": lookup(var.subnet_public[count.index], "subnet_name"),
      "is_public": lookup(var.subnet_public[count.index], "public"),
      "kubernetes.io/role/elb": "1",
      format("%s%s-%s","kubernetes.io/cluster/",lookup(var.tags, "product"),lookup(var.tags, "env")): "owned"
     },
      var.tags)
}


resource "aws_subnet" "subnet_private" {
  count = length(var.subnet_private)
  vpc_id     = aws_vpc.vpc.id
  cidr_block = lookup(var.subnet_private[count.index], "cidr")
  availability_zone = lookup(var.subnet_private[count.index], "az")
  map_public_ip_on_launch = lookup(var.subnet_private[count.index], "public") ? true : false
  tags = merge( 
    {
      "Name": lookup(var.subnet_private[count.index], "subnet_name"),
      "is_public": lookup(var.subnet_private[count.index], "public"),
      "kubernetes.io/role/internal-elb": "1",
      "podsubnet": "true"
      format("%s%s-%s","kubernetes.io/cluster/",lookup(var.tags, "product"),lookup(var.tags, "env")): "owned"
     },
      var.tags)
}

resource "aws_subnet" "subnet_private_db" {
  count = length(var.subnet_private_db)
  vpc_id     = aws_vpc.vpc.id
  cidr_block = lookup(var.subnet_private_db[count.index], "cidr")
  availability_zone = lookup(var.subnet_private_db[count.index], "az")
  map_public_ip_on_launch = lookup(var.subnet_private_db[count.index], "public") ? true : false
  tags = merge( 
    {
      "Name": lookup(var.subnet_private_db[count.index], "subnet_name"),
      "is_public": lookup(var.subnet_private_db[count.index], "public") 
     },
      var.tags)
}