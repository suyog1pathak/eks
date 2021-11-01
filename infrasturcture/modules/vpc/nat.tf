resource "aws_eip" "elasticIp" {
  vpc    = true
  tags = merge(
    {
      "Name": format("%s-%s-%s",var.Name,lookup(var.tags, "env"),"nat-eip")
    },
    var.tags
  )
}


resource "random_shuffle" "publicSub" {
  input        = aws_subnet.subnet_public.*.id
  result_count = 1
}


resource "aws_nat_gateway" "natGateway" {
  allocation_id = aws_eip.elasticIp.id
  subnet_id     = random_shuffle.publicSub.result[0]

  tags = merge(
    {
      "Name": format("%s-%s-%s",var.Name,lookup(var.tags, "env"),"nat")
    },
    var.tags
  )
}