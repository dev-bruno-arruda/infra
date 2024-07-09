provider "aws" {
  region              = "us-east-1"
  profile             = "finance1"
  allowed_account_ids = var.allowed_account_ids
}

# data "terraform_remote_state" "vpc" {
#   backend = "local"
# }

# terraform {
#   backend "s3" {
#     key = "medium-terraform/stage/terraform.tfstate"
#     # ...
#   }
# }

module "network" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 3.0"

  name = var.name

  cidr = var.cidr
  azs  = var.azs

  public_subnets = var.public_subnets

  private_subnets = var.private_subnets

  enable_nat_gateway = true
  enable_vpn_gateway = true

  # Enable Public access to RDS instances
  create_database_subnet_group           = true
  create_database_subnet_route_table     = true
  create_database_internet_gateway_route = true

  enable_dns_hostnames = true
  enable_dns_support   = true


  tags = {
    Terraform   = "true"
    Environment = "stage"
  }
}

# module "alb" {
#   source = "terraform-aws-modules/alb/aws"
#   version = "~> 6.0"

#   #...
# }