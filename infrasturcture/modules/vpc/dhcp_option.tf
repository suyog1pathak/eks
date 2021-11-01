resource "aws_vpc_dhcp_options" "main" {
  domain_name_servers = ["AmazonProvidedDNS"]
  domain_name = format("%s.%s",var.region,"compute.internal")
  tags = merge(
    {
      "Name": format("%s-%s-%s",var.Name,lookup(var.tags, "env"),"DHCP-options")
    },
    var.tags
  )
}

resource "aws_vpc_dhcp_options_association" "dns_resolver" {
  vpc_id          = aws_vpc.vpc.id
  dhcp_options_id = aws_vpc_dhcp_options.main.id
}