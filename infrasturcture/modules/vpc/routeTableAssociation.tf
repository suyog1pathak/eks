resource "aws_route_table_association" "rt_a_public" {
  count = length(var.subnet_public)
  subnet_id    = aws_subnet.subnet_public[count.index].id
  route_table_id = element(aws_route_table.routeTablePublic[*].id, count.index)
}


resource "aws_route_table_association" "rt_a_private" {  
  count = length(var.subnet_private)
  #element(aws_subnet.public[*].id, count.index)
  subnet_id      = aws_subnet.subnet_private[count.index].id
  route_table_id = element(aws_route_table.routeTablePrivate[*].id, count.index)
}

resource "aws_route_table_association" "rt_a_private_db" {  
  count = length(var.subnet_private_db)
  #element(aws_subnet.public[*].id, count.index)
  subnet_id      = aws_subnet.subnet_private_db[count.index].id
  route_table_id = element(aws_route_table.routeTablePrivateDb[*].id, count.index)
}