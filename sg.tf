# Module: allow_http_sg
# Description: This module creates a security group that allows inbound HTTP traffic.
# It allows traffic from any source IP address to the specified port (80) in the VPC.
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

# Module: allow_bastion_sg
# Description: This module creates a security group that allows inbound HTTP traffic from a bastion host.
# It allows traffic from the bastion host's security group to the specified port (80) in the VPC.
module "allow_bastion_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "5.1.2"

  name        = "allow-bastion"
  description = "Allow inbound HTTP traffic from bastion"
  vpc_id      = module.vpc.vpc_id

  ingress_with_source_security_group_id = [
    {
      from_port                = 80
      to_port                  = 80
      protocol                 = "tcp"
      description              = "Allow HTTP traffic from bastion"
      source_security_group_id = module.allow_http_sg.security_group_id
    }
  ]

  egress_cidr_blocks = ["0.0.0.0/0"]
  egress_rules       = ["all-all"]

  tags = {
    Name      = "allow-bastion"
    Terraform = "true"
  }
}

# Module: allow_ssh
# Description: This module creates a security group that allows inbound SSH traffic.
# It allows traffic from any source IP address to the specified port (22) in the VPC.
# Note: This security group is not attached to any instance by default and can be attached to any instance that needs SSH access.
module "allow_ssh" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "5.1.2"

  name        = "allow-ssh"
  description = "Allow SSH inbound traffic"
  vpc_id      = module.vpc.vpc_id

  ingress_cidr_blocks = ["0.0.0.0/0"]
  ingress_rules       = ["ssh-tcp"]
  egress_cidr_blocks  = ["0.0.0.0/0"]
  egress_rules        = ["all-all"]
}