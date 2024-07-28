terraform {
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

  azs             = var.availabilty-zones
  private_subnets = var.private_subnets
  public_subnets  = var.public_subnets

  tags = {
    Name      = var.vpc-name
    Terraform = "true"
  }
}

