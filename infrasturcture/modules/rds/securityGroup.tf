resource "aws_security_group" "rdsSg" {
  name        = format("%s-%s-%s-%s",lookup(var.data, "name"),lookup(var.tags, "product"),lookup(var.tags, "env"),"rds-sg")
  description = lookup(var.data, "name")
  vpc_id      = var.vpcId


    ingress {
    description      = "All Traffic from VPC"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = [var.vpcCidr]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags        = merge(
   {
     "Name": format("%s-%s-%s-%s",lookup(var.data, "name"),lookup(var.tags, "product"),lookup(var.tags, "env"),"rds-sg")
   },
   var.tags
  )
}