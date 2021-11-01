

resource "aws_network_acl" "main" {
  vpc_id = aws_vpc.vpc.id
  subnet_ids = concat([for s in aws_subnet.subnet_private : s.id], [for k in aws_subnet.subnet_public : k.id], [for k in aws_subnet.subnet_private_db : k.id])
  egress {
    protocol   = -1
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  ingress {
    protocol   = -1
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  tags = merge(
    {
      "Name": format("%s-%s-%s",var.Name,lookup(var.tags, "env"),"NACL")
    },
    var.tags
  )
}