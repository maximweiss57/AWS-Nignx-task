Pre-requisites:
Basic knowledge of Docker, Terraform, Linux and AWS.
Terraform installed on your machine.
configured the AWS CLI with the needed credentials.

This repo contains:
- A Dockerfile to build a Docker image based on the official Nginx image, with a custom index.html file that returnes "yo this is nignx".
note: the dockerfile is only for demonstration purposes, when terraform runs, it will build the image and run the container on the main instance using "user data" script.

- Few terraform files to deploy the Docker container on AWS.
    - `main.tf` to create the needed infrastructure.
        this file define the provider and terraform and creates the vpc with one private and one public subnet, internet gateway and Nat gateway for secure connection for the private subnet.
    - `sg.tf` to create the security group.
        2 security groups are created, 
        one for the Bastion host, that will redirect the traffic to the main ec2 instance.
        the other for the main ec2 instance, that will allow the traffic from the bastion host.
    - `instances.tf` to create EC2 instances.
        2 instances are created, the first ine is a bastion host that will serve as a reverse proxy to the instance in the private subnet, and the second one is the main instance that will run the custom nginx container.
    - `variables.tf` to initialize variables.
        vpc variables are defined in this file.
    - `auto.tfvars` to define the variables.
        in this file you can change the variables as you see fit.(except of vpc variables)

How this works:
When you write the command `terraform apply` or `terrafirm apply --auro-approve` (to skip the stage that terraform asks you if you are sure) in the terminal, terraform will create the infrastructure defined in the terraform files.:
- A VPC with 2 subnets(one private and one public) will be created.
- 3 security groups will be created 
    - 1 for the bastion host that allow traffic on port 80.
    - 1 for the main instance that allows traffic only from the instance with the bastion's hosts security group.
    - 1 for allowing ssh traffic but wont be used by default, and can be attached if needed.
- 2 EC2 instances will be created, one in each subnet.
    - The bastion host will be created in the public subnet.
    - The main instance will be created in the private subnet.
- The bastion host will redirect the traffic to the main instance.
    terraform will run a script that installs and configures nginx server to redirect the traffic to the main instance.
- The main instance will run the nginx container.
    a script will install docker and create a docker image and run a container with it

Github actions:
pre-requisites:
- AWS IAM user with the needed permissions.
- configured the github secrets with the AWS IAM user credentials.
- workflow files to automate the deployment process.