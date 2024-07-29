# this file is used to initialize the variables that will be used in the main.tf file
variable "aws-region" {
  description = "The AWS region to deploy resources."
  default     = "eu-central-1" # Frankfurt
}

variable "vpc-name" {
  description = "The name of the VPC."
  default     = "my-vpc"
}

variable "availabilty-zones" {
  description = "The availabilty zones for the VPC."
  default     = ["eu-central-1a", "eu-central-1b", "eu-central-1c"]
}

variable "private_subnets" {
  description = "The private subnets for the VPC."
  default     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}

variable "public_subnets" {
  description = "The public subnets for the VPC."
  default     = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
}

variable "cidr-block" {
  description = "The CIDR block for the VPC."
  default     = "10.0.0.0/16"
}

variable "bastion-ami" {
  description = "The AMI to use for the bastion instance."
  default     = "ami-071878317c449ae48" #amazon linux 2 in eu-central-1
}

variable "custom-ami" {
  description = "The AMI to use for the custom instance."
  default     = "ami-071878317c449ae48" #amazon linux 2 in eu-central-1

}
variable "bastion-instance-name" {
  description = "name for the bastion instance"
  default     = "bastion"
}

variable "custom-instance-name" {
  description = "name for the custom instance"
  default     = "nginx"
}