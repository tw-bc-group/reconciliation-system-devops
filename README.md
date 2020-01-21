# reconciliation-system-devops

## How to use

### Install terraform

Follow terraform installation docs.

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
