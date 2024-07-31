Pre-requisites:
- Basic knowledge of Docker, Terraform, Linux, and AWS.
- Terraform installed on your machine.
- AWS CLI configured with the needed credentials.

To switch between remote and local Terraform state, edit the `main.tf` file and comment/uncomment the needed lines.

This repo contains:
- A Dockerfile to build a Docker image based on the official Nginx image, with a custom index.html file that returns "yo this is nginx".
  Note: The Dockerfile is only for demonstration purposes. When Terraform runs, it will build the image and run the container on the main instance using a "user data" script.

- Several Terraform files to deploy the Docker container on AWS:
  - `main.tf` to create the needed infrastructure.
    This file defines the provider and Terraform settings, and creates the VPC with one private and one public subnet, internet gateway, and NAT gateway for secure connection for the private subnet.
  - `sg.tf` to create the security groups.
    Two security groups are created:
    - One for the Bastion host, which will redirect the traffic to the main EC2 instance.
    - Another for the main EC2 instance, which will allow traffic from the Bastion host.
  - `instances.tf` to create EC2 instances.
    Two instances are created:
    - The first one is a Bastion host that will serve as a reverse proxy to the instance in the private subnet.
    - The second one is the main instance that will run the custom Nginx container.
  - `variables.tf` to initialize variables.
    VPC variables are defined in this file.
  - `auto.tfvars` to define the variables.
    In this file, you can change the variables as you see fit (except for VPC variables).

How this works:
When you run the command `terraform apply` or `terraform apply --auto-approve` (to skip the confirmation stage) in the terminal, Terraform will create the infrastructure defined in the Terraform files:
- A VPC with 2 subnets (one private and one public) will be created.
- 2 security groups will be created:
  - 1 for the Bastion host that allows traffic on port 80.
  - 1 for the main instance that allows traffic only from the instance with the Bastion host's security group.
- 2 EC2 instances will be created, one in each subnet
  - The Bastion host will be created in the public subnet.
  - The main instance will be created in the private subnet.
- The Bastion host will redirect the traffic to the main instance.
  Terraform will run a script that installs and configures the Nginx server to redirect the traffic to the main instance.
- The main instance will run the Nginx container.
  A script will install Docker, create a Docker image, and run a container with it.

GitHub Actions:
Pre-requisites:
- AWS IAM user with the needed permissions.
- GitHub secrets configured with the AWS IAM user credentials.
- S3 bucket to store the Terraform state file.
- Workflow files to automate the deployment process.

How this works:
- When you push/merge the code to the main branch, GitHub Actions will run the workflow files.
- The workflow files will run the Terraform commands to create the infrastructure.
  - The Terraform state file will be stored in the S3 bucket.
- To destroy the infrastructure, run the destroy workflow from the Actions tab.

![yo-nginx (3)](https://github.com/user-attachments/assets/c8d00267-d834-4610-942b-3c5ddda0e92d)
