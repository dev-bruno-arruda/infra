output "vpc_id" {
  description = "ID of the VPC"
  value       = module.network.vpc_id
}

output "private_subnets" {
  description = "List of IDs of private subnets"
  value       = module.network.private_subnets
}

output "public_subnets" {
  description = "List of IDs of public subnets"
  value       = module.network.public_subnets
}

output "sec_groups" {
  description = "List of SG"
  value       = [aws_security_group.allow_mariadb.id, aws_security_group.allow_http_in.id]
}

# output "db_address" {
#   description = "List of database endpoints"
#   value       = aws_db_instance.f1clone.endpoint
# }

output "s3_endpoint" {
  description = "List of s3 endpoints"
  value       = aws_s3_bucket.f1-wordpress-prod.bucket_regional_domain_name
}

# output "ec2_public_ip" {
#   description = "List of ec2 public ips"
#   value       = aws_instance.wordpress.public_ip
# }

# output "lb_dns_name" {
#   description = "List of DNS names"
#   value       = aws_lb.lb_wordpress_stage.dns_name
# }


# output "db_password" {
#   description = "Database password"
#   sensitive = true
#   value       = module.db.db_instance_password 
# }