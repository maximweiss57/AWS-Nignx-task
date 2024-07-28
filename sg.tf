module "allow_http_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "5.1.2"

  name        = "allow-http"
  description = "Allow HTTP inbound traffic"
  vpc_id      = module.vpc.vpc_id
  

  ingress_cidr_blocks = ["0.0.0.0/0"]
  ingress_rules       = ["http-80-tcp"]
  egress_cidr_blocks  = ["0.0.0.0/0"]
  egress_rules        = ["all-all"]

  tags = {
    Name      = "allow-http"
    Terraform = "true"
  }
}
module "allow_bastion_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "5.1.2"

  name        = "allow-bastion"
  description = "Allow inbound traffic from bastion"
  vpc_id      = module.vpc.vpc_id

  # Allow SSH traffic only from instances with the "allow-http" security group
  ingress_with_source_security_group_id = [
    {
      rule                    = "ssh-tcp"
      source_security_group_id = module.allow_http_sg.security_group_id
    }
  ]

  egress_cidr_blocks = ["0.0.0.0/0"]
  egress_rules        = ["all-all"]

  tags = {
    Name      = "allow-bastion"
    Terraform = "true"
  }
}