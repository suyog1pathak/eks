resource "aws_vpc" "vpc" {
  cidr_block = var.cidr_block
  enable_dns_support = var.enable_dns_support
  enable_dns_hostnames = var.enable_dns_hostnames
  tags = merge(
    { 
      "Name":  format("%s-%s",var.Name,lookup(var.tags, "env"))
    }, 
    var.tags)
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.vpc.id
  tags = merge(
    { 
      "Name": format("%s-%s-%s",var.Name,lookup(var.tags, "env"),"igw") 
      }, 
      var.tags)
}