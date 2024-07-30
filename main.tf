# terraform {
#   required_providers {
#     aws = {
#       source  = "hashicorp/aws"
#       version = ">= 5.30.0"
#     }
#   }
# }

terraform {
  backend "s3" {
    region = "eu-central-1"
    key    = "terraform-state"
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.30.0"
    }
  }
}

provider "aws" {
  region = var.aws-region
}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = var.vpc-name
  cidr = var.cidr-block

  azs                = var.availability_zones
  private_subnets    = var.private_subnets
  public_subnets     = var.public_subnets
  enable_nat_gateway = true # Enable NAT gateway creation
  single_nat_gateway = true # Create a single NAT gateway

  public_subnet_tags = {
    Name = "public-subnet"
  }

  private_subnet_tags = {
    Name = "private-subnet"
  }

  tags = {
    Name      = var.vpc-name
    Terraform = "true"
  }
}

