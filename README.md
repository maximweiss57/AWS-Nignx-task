Pre-requisites:
Basic knowledge of Docker, Terraform, Linux and AWS.
Terraform installed on your machine.
configured the AWS CLI with the needed credentials.

This repo contains:
- A Dockerfile to build a Docker image based on the official Nginx image, with a custom index.html file that returnes "yo this is nignx".

- Few terraform files to deploy the Docker container on AWS.
    - `main.tf` to create the needed infrastructure.
        this file define the provider and terraform and creates the vpc &subnets
    - `sg.tf` to create the security group.
        2 security groups are created, 
        one for the Bastion host, that will redirect the traffic to the main ec2 instance.
        the other for the main ec2 instance, that will allow the traffic from the bastion host.
    - `instances.tf` to create EC2 instances.
        2 instances are created, the first ine is a bastion host, and the second one is the main instance that will run the nginx container.
    - `variables.tf` to define the variables.
        used to define the variables that will be used in the terraform files.
    - `vars.tfvars` to define the variables.
        in this file you can change the variables as you see fit.

- workflow files to automate the deployment process.

How this works:
After hitting terrfaorm apply, the following will happen:
- A VPC with 2 subnets will be created.
- 2 security groups will be created
- 2 EC2 instances will be created, one in each subnet.
- The bastion host will redirect the traffic to the main instance.
- The main instance will run the nginx container.