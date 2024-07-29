locals {
  nginx-private-ip = aws_instance.nginx.private_ip
}

resource "aws_instance" "bastion" {
  ami                         = var.bastion-ami
  instance_type               = "t2.micro"
  vpc_security_group_ids      = [module.allow_http_sg.security_group_id]
  subnet_id                   = module.vpc.public_subnets[0]
  associate_public_ip_address = true

  user_data = <<-EOF
              #!/bin/bash
              sudo yum update -y
              sudo yum install -y nginx
              sudo systemctl start nginx
              sudo systemctl enable nginx
              PUBLIC_IP=$(curl -s http://169.254.169.254/latest/meta-data/public-ipv4)
              # Configure NGINX
              cat << 'EOF_NGINX' | sudo tee /etc/nginx/conf.d/default.conf
              server {
                  listen 80;

                  # Define the server name (public IP of the EC2 instance in the public subnet)
                  server_name $(PUBLIC_IP);

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
              
              sudo systemctl restart nginx
              EOF

  tags = {
    Name      = var.bastion-instance-name
    Terraform = "true"
  }
}

resource "aws_instance" "nginx" {
  ami                    = var.custom-ami
  instance_type          = "t2.micro"
  vpc_security_group_ids = [module.allow_bastion_sg.security_group_id]
  subnet_id              = module.vpc.private_subnets[0]
  user_data              = <<-EOF
              #!/bin/bash
              sudo yum update -y
              sudo yum install -y docker
              sudo systemctl start docker
              sudo systemctl enable docker
              echo "#using the latest NGINX image from the Docker Hub
              FROM nginx:latest
              #entrypoint to the appropriate NGINX executable and
              #making sure the NGINX server is running in the foreground
              ENTRYPOINT [ "/usr/sbin/nginx", "-g", "daemon off;"]
              #edit the default index.html file to display a the needed message
              RUN echo "yo this is nginx" > /usr/share/nginx/html/index.html
              #expose the port 80
              EXPOSE 80" > Dockerfile
              sudo docker build -t yo-image
              sudo docker run --name yo-nginx -d -p 80:80 yo-image
              EOF
  tags = {
    Name      = var.custom-instance-name
    Terraform = "true"
  }
}
 