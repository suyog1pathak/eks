output "vpcId" {
  value = aws_vpc.vpc.id
}

output "publicSubnets" {
  value = aws_subnet.subnet_public.*.id
}

output "privateSubnets" {
  value = aws_subnet.subnet_private.*.id
}

output "dbSubnets" {
  value = aws_subnet.subnet_private_db.*.id
}