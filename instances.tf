resource "aws_instance" "bastion" {
  ami                    = var.bastion-ami
  instance_type          = "t2.micro"
  vpc_security_group_ids = [module.allow_http_sg.security_group_id]
  subnet_id              = module.vpc.public_subnets[0]
  tags = {
    Name      = var.bastion-instance-name
    Terraform = "true"
  }
}

resource "aws_instance" "nginx" {
  ami                    = var.caustom-ami
  instance_type          = "t2.micro"
  vpc_security_group_ids = [module.allow_bastion_sg.security_group_id]
  subnet_id              = module.vpc.private_subnets[0]
  tags = {
    Name      = var.custom-instance-name
    Terraform = "true"
  }
}