output "vpc_id" {
  value = module.vpc.vpc_id
}

output "public_subnets" {
  value = module.vpc.public_subnets
}

output "private_subnets" {
  value = module.vpc.private_subnets
}

output "availability_zones" {
  description = "Availability zones used by the public subnets"
  value = distinct([for s in module.vpc.public_subnet_objects: try(s.availability_zone, "")])
}
