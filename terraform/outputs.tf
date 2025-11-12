output "vpc_id" {
  description = "The ID of the VPC"
  value       = try(module.vpc.vpc_id, null)
}

output "vpc_cidr_block" {
  description = "The CIDR block of the VPC"
  value       = try(module.vpc.vpc_cidr_block, null)
}

output "public_subnet_ids" {
  description = "IDs of public subnets"
  value       = try(module.vpc.public_subnet_ids, [])
}

output "private_subnet_ids" {
  description = "IDs of private subnets"
  value       = try(module.vpc.private_subnet_ids, [])
}

# если полезно видеть, какие EC2 создались (map по each.key)
output "ec2_instances" {
  description = "EC2 instances module outputs (map)"
  value       = try(module.ec2, {})
}

output "alb_dns_name" {
  description = "ALB DNS name"
  value       = try(module.alb.lb_dns_name, null)
}