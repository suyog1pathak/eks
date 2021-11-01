variable "vpc_vars" {
  type = any
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

variable "default_tags" {
  type = map
}

variable "security_groups" {
  type = list
}

variable "rds_data" {
  type = any
}

variable "neptune_data" {
  type = any
}

variable "elasticache_data" {
  type = any
}

variable "msk_data" {
  type = any
}

# variable "publicSubnets" {
#   type = any
# }

# variable "privateSubnets" {
#   type = any
# }

# variable "vpcId" {
#   type = string
# }