This repo contains:
- A Dockerfile to build a Docker image based on the official Nginx image, with a custom index.html file.

- Few terraform files to deploy the Docker container on AWS.
    - `main.tf` to create the needed infrastructure.
    - `sg.tf` to create the security group.
    - `variables.tf` to initialize the variables.
    - `vars.tfvars` to define the variables.

- workflow files to automate the deployment process.


    