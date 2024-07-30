# Module: allow_http_sg
# Description: This module creates a security group that allows inbound HTTP traffic.
# It allows traffic from any source IP address to the specified port (80) in the VPC.
module "allow_http_sg" {
  source  = "terraform-aws-modules/security-group/aws"  # Source of the security group module
  version = "5.1.2"  # Version of the module to use

  name        = "allow-http"  # Name of the security group
  description = "Allow HTTP inbound traffic"  # Description of the security group
  vpc_id      = module.vpc.vpc_id  # VPC ID where the security group will be created

  ingress_cidr_blocks = ["0.0.0.0/0"]  # Allow inbound traffic from any IP address
  ingress_rules       = ["http-80-tcp"]  # Allow inbound HTTP traffic on port 80
  egress_cidr_blocks  = ["0.0.0.0/0"]  # Allow outbound traffic to any IP address
  egress_rules        = ["all-all"]  # Allow all outbound traffic

  tags = {
    Name      = "allow-http"  # Tag for the security group
    Terraform = "true"  # Tag to indicate the resource is managed by Terraform
  }
}

# Module: allow_bastion_sg
# Description: This module creates a security group that allows inbound HTTP traffic from a bastion host.
# It allows traffic from the bastion host's security group to the specified port (80) in the VPC.
module "allow_bastion_sg" {
  source  = "terraform-aws-modules/security-group/aws"  # Source of the security group module
  version = "5.1.2"  # Version of the module to use

  name        = "allow-bastion"  # Name of the security group
  description = "Allow inbound HTTP traffic from bastion"  # Description of the security group
  vpc_id      = module.vpc.vpc_id  # VPC ID where the security group will be created

  ingress_with_source_security_group_id = [
    {
      from_port                = 80  # Start of the port range for the rule
      to_port                  = 80  # End of the port range for the rule
      protocol                 = "tcp"  # Protocol for the rule
      description              = "Allow HTTP traffic from bastion"  # Description of the rule
      source_security_group_id = module.allow_http_sg.security_group_id  # Source security group ID for the rule
    }
  ]

  egress_cidr_blocks = ["0.0.0.0/0"]  # Allow outbound traffic to any IP address
  egress_rules       = ["all-all"]  # Allow all outbound traffic

  tags = {
    Name      = "allow-bastion"  # Tag for the security group
    Terraform = "true"  # Tag to indicate the resource is managed by Terraform
  }
}