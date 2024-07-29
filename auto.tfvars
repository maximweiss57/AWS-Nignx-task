#this file is used to store the variables that will be used in the main.tf file
aws-region            = "eu-central-1"
vpc-name              = "Nginx-VPC"
availabilty-zones     = ["euc1-az1"]
cidr-block            = "10.0.0.0/16"
private_subnets       = ["10.0.1.0/24"]
public_subnets        = ["10.0.101.0/24"]
bastion-ami           = ""
custom-ami            = ""
custom-instance-name  = "nginx"
bastion-instance-name = "bastion"