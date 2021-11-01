variable "cidr_block" {
  type        = string
  description = "CIDR for VPC Creation"
}

variable "region" {
  type        = string
  description = "region"
}

variable "Name" {
  type = string
  description = "VPC Name" 
}

variable "enable_dns_support" {
    type = bool
    default = true
    description = "enable_dns_support for vpc"
}

variable "enable_dns_hostnames" {
    type = bool
    default = true
    description = "enable_dns_hostnames for vpc"
}

variable "tags" {
  type = map
  description = "Tags for vpc creation"
}

variable "subnet_public" {
  type = list
}

variable "subnet_private" {
  type = list
}

variable "subnet_private_db" {
  type = list
}

variable "route_tables_public" {
  type = list
}

variable "route_tables_private" {
  type = list
}

variable "route_tables_private_db" {
  type = list
}