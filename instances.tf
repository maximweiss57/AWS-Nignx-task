# This Terraform file defines two AWS EC2 instances: a bastion instance and an nginx instance.
# The bastion instance is used as a jump host to access the private subnet where the nginx instance is located.
# The nginx instance runs an NGINX web server inside a Docker container.

# Define local variables
locals {
  # Private IP of the nginx instance
  nginx-private-ip = aws_instance.nginx.private_ip
}

# Define the bastion instance
resource "aws_instance" "bastion" {
  # AMI ID for the bastion instance
  ami                         = var.bastion-ami
  # Instance type for the bastion instance
  instance_type               = "t2.micro"
  # Security group IDs for the bastion instance
  vpc_security_group_ids      = [module.allow_http_sg.security_group_id]
  # Subnet ID for the bastion instance (public subnet)
  subnet_id                   = module.vpc.public_subnets[0]
  # Associate a public IP address with the bastion instance
  associate_public_ip_address = true
  # User data script to configure the bastion instance
  user_data                   = <<-EOF
              #!/bin/bash
              # Install NGINX
              sudo yum install -y nginx
              # Start NGINX service
              sudo systemctl start nginx
              # Enable NGINX to start on boot
              sudo systemctl enable nginx
              # Get the public IP of the instance
              PUBLIC_IP=$(curl -s http://169.254.169.254/latest/meta-data/public-ipv4)
              # Configure NGINX
              cat << 'EOF_NGINX' | sudo tee /etc/nginx/conf.d/default.conf
              server {
                  listen 80;

                  # Define the server name (public IP of the EC2 instance in the public subnet)
                  server_name $PUBLIC_IP;

                  location / {
                      # Forward (proxy) the request to the web server in the private subnet
                      proxy_pass http://${local.nginx-private-ip}:80;

                      # Set headers to preserve the client's original information
                      proxy_set_header Host \$host;
                      proxy_set_header X-Real-IP \$remote_addr;
                      proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
                      proxy_set_header X-Forwarded-Proto \$scheme;
                  }
              }
              EOF_NGINX
              
              # Restart NGINX service to apply the configuration
              sudo systemctl restart nginx
              EOF

  # Tags for the bastion instance
  tags = {
    Name      = var.bastion-instance-name
    Terraform = "true"
  }
}

# Define the nginx instance
resource "aws_instance" "nginx" {
  # AMI ID for the nginx instance
  ami                    = var.custom-ami
  # Instance type for the nginx instance
  instance_type          = "t2.micro"
  # Security group IDs for the nginx instance
  vpc_security_group_ids = [module.allow_bastion_sg.security_group_id]
  # Subnet ID for the nginx instance (private subnet)
  subnet_id              = module.vpc.private_subnets[0]
  # User data script to configure the nginx instance
  user_data              = <<-EOF
              #!/bin/bash
              # Install Docker
              sudo yum install -y docker
              # Start Docker service
              sudo systemctl start docker
              # Enable Docker to start on boot
              sudo systemctl enable docker
              
              # Create Dockerfile for NGINX
              cat << 'EOF_NGINX' > /home/ec2-user/dockerfile
              FROM nginx:latest
              ENTRYPOINT [ "/usr/sbin/nginx", "-g", "daemon off;" ]
              RUN echo "yo this is nginx" > /usr/share/nginx/html/index.html
              EXPOSE 80
              EOF_NGINX

              # Build and run Docker container
              sudo docker build -t yo-image /home/ec2-user/
              sudo docker run --name yo-nginx -d -p 80:80 yo-image
              EOF
  # Tags for the nginx instance
  tags = {
    Name      = var.nginx-instance-name
    Terraform = "true"
  }
}