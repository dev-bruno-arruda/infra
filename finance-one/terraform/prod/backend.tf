terraform {
  backend "s3" {
    encrypt = true
    bucket  = "terraform-state-financeone"
    key     = "terraform-state-financeone-prod"
    region  = "us-east-1"
    profile = "finance1"
  }
  #   required_providers {
  #     aws = {
  #       source  = "hashicorp/aws"
  #       version = "4.15.0"
  #     }
  #   }
}