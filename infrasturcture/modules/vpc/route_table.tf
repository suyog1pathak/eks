
resource "aws_route_table" "routeTablePublic" {

  count = length(var.route_tables_public)
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id 
  }
  
  tags = merge( 
    {
    "Name": lookup(var.route_tables_public[count.index], "name"), 
    "is_public": lookup(var.route_tables_public[count.index], "public")
    }, 
    var.tags)
}


resource "aws_route_table" "routeTablePrivate" {

  count = length(var.route_tables_private)
  vpc_id = aws_vpc.vpc.id
  # route {
  #   cidr_block = "0.0.0.0/0"
  #   gateway_id = aws_nat_gateway.natGateway.id 
  # }  
  tags = merge( {"Name": lookup(var.route_tables_private[count.index], "name"), "is_public": lookup(var.route_tables_private[count.index], "public")}, var.tags)
}

resource "aws_route" "routeTablePrivateRoute" {
  #count = length(aws_route_table.routeTablePrivate)
  route_table_id              = aws_route_table.routeTablePrivate[0].id
  destination_cidr_block      = "0.0.0.0/0"
  nat_gateway_id              = aws_nat_gateway.natGateway.id
}




resource "aws_route_table" "routeTablePrivateDb" {

  count = length(var.route_tables_private_db)
  vpc_id = aws_vpc.vpc.id
  
  tags = merge( {"Name": lookup(var.route_tables_private_db[count.index], "name"), "is_public": lookup(var.route_tables_private_db[count.index], "public")}, var.tags)
}