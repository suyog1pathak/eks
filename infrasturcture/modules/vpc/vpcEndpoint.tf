# resource "aws_security_group" "endpointSg" {
#   name        = format("%s-%s-%s-%s",var.name,lookup(var.tags, "env"),"s3endpoint-sg")
#   description = var.name
#   vpc_id      = aws_vpc.vpc.id


#     ingress {
#     description      = "All Traffic from VPC"
#     from_port        = 0
#     to_port          = 0
#     protocol         = "-1"
#     cidr_blocks      = [aws_vpc.vpc.id]
#   }

#   egress {
#     from_port        = 0
#     to_port          = 0
#     protocol         = "-1"
#     cidr_blocks      = ["0.0.0.0/0"]
#     ipv6_cidr_blocks = ["::/0"]
#   }

#   tags        = merge(
#    {
#      "Name": format("%s-%s-%s-%s",var.name,lookup(var.tags, "product"),lookup(var.tags, "env"),"s3endpoint-sg")
#    },
#    var.tags
#   )
# }


resource "aws_vpc_endpoint" "s3" {
  vpc_id       = aws_vpc.vpc.id
  service_name = format("%s.%s.%s","com.amazonaws",var.region,"s3")
  vpc_endpoint_type = "Gateway"
  route_table_ids = [aws_route_table.routeTablePrivate[0].id]
  tags        = merge(
   {
     "Name": format("%s-%s-%s",var.Name,lookup(var.tags, "env"),"s3endpoint")
   },
   var.tags
  )

}

resource "aws_vpc_endpoint" "ecrApi" {
  vpc_id       = aws_vpc.vpc.id
  service_name = format("%s.%s.%s","com.amazonaws",var.region,"ecr.api")
  vpc_endpoint_type = "Interface"
  security_group_ids = [
    aws_security_group.ecrapi-endpoint.id,
  ]
  tags        = merge(
   {
     "Name": format("%s-%s-%s",var.Name,lookup(var.tags, "env"),"ecrapi-endpoint")
   },
   var.tags
  )

}

resource "aws_security_group" "ecrapi-endpoint" {
  name        = format("%s-%s-%s-%s-%s",var.Name,lookup(var.tags, "product"),lookup(var.tags, "env"),"ecrapi-endpoint","sg")
  description = var.Name
  vpc_id      = aws_vpc.vpc.id


    ingress {
    description      = "All Traffic from VPC"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = [var.cidr_block]
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
     "Name": format("%s-%s-%s-%s-%s",var.Name,lookup(var.tags, "product"),lookup(var.tags, "env"),"ecrapi-endpoint","sg")
   },
   var.tags
  )
}


resource "aws_vpc_endpoint" "ecrDkr" {
  vpc_id       = aws_vpc.vpc.id
  service_name = format("%s.%s.%s","com.amazonaws",var.region,"ecr.dkr")
  vpc_endpoint_type = "Interface"
  security_group_ids = [
    aws_security_group.ecrdkr-endpoint.id,
  ]
  tags        = merge(
   {
     "Name": format("%s-%s-%s",var.Name,lookup(var.tags, "env"),"ecrdkr-endpoint")
   },
   var.tags
  )

}


resource "aws_security_group" "ecrdkr-endpoint" {
  name        = format("%s-%s-%s-%s-%s",var.Name,lookup(var.tags, "product"),lookup(var.tags, "env"),"ecrdkr-endpoint","sg")
  description = var.Name
  vpc_id      = aws_vpc.vpc.id


    ingress {
    description      = "All Traffic from VPC"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = [var.cidr_block]
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
     "Name": format("%s-%s-%s-%s-%s",var.Name,lookup(var.tags, "product"),lookup(var.tags, "env"),"ecrdkr-endpoint","sg")
   },
   var.tags
  )
}