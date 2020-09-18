# Terraform
Terraform is a tool for building, changing, and versioning infrastructure safely and efficiently. Terraform can manage existing and popular service providers as well as custom in-house solutions. Here you'll find terraform files to create infrastructure on AWS.
Ref: https://www.terraform.io/intro/index.html

## Installation

- Download apropiate package from here: https://releases.hashicorp.com/terraform/0.12.23/
- Unzip package and copy `terraform` binary in `/usr/bin`
- Make sure than `terraform path` is aviable on PATH variable
- Verify the installation worked: run command `terraform --version` in the terminal. 


## Files structure

### `main.tf`
Define all resources that we use to generate the infrastructure that we need. For ECS cluster I don't use only main.tf file, instead I use one tf file regarding the resource I have to create, for example:
`alb.tf` 		===> will create application load balancer
`security.tf`	===> will create security group for alb and service
`ecs.tf`		===> wll create ecs cluster

### `variables.tf`
Declare all variables to use in `main.tf`.

### `*.tfvars`
In all files `.tfvars` we define the values of the all variables. The default file is named `terraform.tfvars`  any other should be added with the following flag `-var-file = file_path`. This file doesn't exists on this repository so you have to create it and define all your variables.

### `backend.tf`
Define method to store remote state, in this case we use an `s3 bucket`.



## Usage
You must create a file called `main.tf` where you will write the definition of what you want to create, like a source code.
Here is an example of the contents of the `main.tf` file:

```
resource "aws_s3_bucket" "main" {
  bucket 		= var.bucket_name
  acl 			= "private"
  force_destroy = true
}
```

To create the infrastructure defined above we can use the following commands

- **Init**: Initialize terraform environment, loading terraform state and modules.
 
 ```sh
 $ cd 'terraform_path' && terraform int -backend-config='bucket=bucket_name' -backend-config='key=s3_bucket_path' -backend-config='region=aws_region' 
 ```

- **Plan**: Syntax validation and inspect resurces to apply.
 
 ```sh
 $ terraform plan -var-file=var_file_path
 ```

 - **Apply**: Apply or create definition.
 
 ```sh
 $ terraform aply -var-file=var_file_path
 ```

### Resources
- `aws/projects/*`