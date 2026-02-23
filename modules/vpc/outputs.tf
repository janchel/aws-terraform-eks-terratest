output "vpc_id" {
  value = module.vpc.vpc_id
}

output "public_subnets" {
  value = module.vpc.public_subnets
}

output "private_subnets" {
  value = module.vpc.private_subnets
}

output "public_subnet_objects" {
  description = "Forwarded list of public subnet objects from underlying module"
  value       = try(module.vpc.public_subnet_objects, [])
}

output "availability_zones" {
  description = "Availability zones used by the public subnets"
  value = try(module.vpc.azs, distinct([for s in try(module.vpc.public_subnet_objects, []): try(s.availability_zone, "")]))
}
