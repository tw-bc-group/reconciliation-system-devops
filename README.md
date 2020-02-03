# reconciliation-system-devops

## How to use

### Install terraform

Follow terraform [installation docs](https://www.terraform.io/downloads.html).

### Prepare
* Copy `secret.auto.tfvars.example` to `secret.auto.tfvars`, and fill in the blank of `access_key` and `secret_key` from AWS account credential.
* Copy `terraform.tfvars.example` to `terraform.tfvars`, and fill in the value of each properties.
* Before execute the script, you can use `terraform plan` to verify the code and see what will happen when you execute the script.

### Create instance

``` bash

cd terraform
terraform apply

```

This script will create two instances on aws. The ci instance config is located at `./terraform/aws_ec2_ci.tf`

### Destroy instance

``` bash

cd terraform
terraform destroy

```
