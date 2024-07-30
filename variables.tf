# this file initializes the variables that will be used in the main.tf file
variable "aws-region" {
  description = "The AWS region to deploy resources."
  default     = "eu-central-1" # Frankfurt
}

variable "vpc-name" {
  description = "The name of the VPC."
  default     = "my-vpc"
}

variable "availability_zones" {
  description = "The availabilty zones for the VPC."
  default     = ["eu-central-1a"]
}

variable "private_subnets" {
  description = "The private subnets for the VPC."
  default     = ["10.0.1.0/24"]
}

variable "public_subnets" {
  description = "The public subnets for the VPC."
  default     = ["10.0.101.0/24"]
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

variable "nginx-instance-name" {
  description = "name for the custom instance"
  default     = "nginx"
}