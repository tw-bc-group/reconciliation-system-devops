# reconciliation-system-devops

## How to use

### Install terraform

* Follow terraform [installation docs](https://www.terraform.io/downloads.html).
* You can use `terraform version` to verify whether you had install successfully. [The version should more than 0.12.18]

### Prepare

> Check to see whether the region you are using is in the `amis` list, The setting is located at `terraform/variables.tf` file's `amis` default value.
> If not, you can go to page `https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/finding-an-ami.html` to find a ami in your region, and add that below the `amis` default value at `terraform/variables.tf`.

* Make sure you are in the `terraform` folder.
* Copy `secret.auto.tfvars.example` to `secret.auto.tfvars` in terraform folder, and fill in the blank of `access_key` and `secret_key` from AWS account credential.
* Copy `terraform.tfvars.example` to `terraform.tfvars` in terraform folder, and fill in the value of each properties.
> Warning: The port **80**, **8080**, **443** is not available in AWS China, please avoid to use these ports.
* Use `terraform init` to initialize the module we use.
* Before execute the script, you can use `terraform plan` to verify the code and see what will happen when you execute the script.

### Create instance

``` bash
terraform apply
```

This script will create two instances on aws. The ci instance config is located at `./terraform/aws_ec2_ci.tf`

### Verify

* After a time of period, If you see the output says it `Apply complete!` as the picture shows below, That means you execute the script successfully.
![terraform apply result](images/terraform_result.jpg)
* From the output, you can know the value of `ci_instance_ip_addr`. It means the IP address of CI instance, you can access the Jenkins page by using that IP address with the port that you specify it in the `terraform.tfvars` file. Such as `http://52.83.54.30:8001`.
* When you access to the Jenkins page, it will ask you to input the `initialAdminPassword`, You can ssh to the instance to get this password. The key file is located at `terraform/secrets` folder.
* Use `ssh -i **.pem ubuntu@ci_instance_ip_addr` to login to the instance, and you can get the `initialAdminPassword`.

### Destroy instance

``` bash
terraform destroy
```

This script will destroy every resource that you created by using `terraform apply`.

> Notice: <br/> 
> The files in folder `terraform/redis_backup` are using to create an EC2 instance with Redis installed. <br/>
> If you need it, please move the file under `terraform/redis_backup` to `terraform` folder. <br/>
> Then you can see these resources when you execute `terraform plan`.

## Deployment

### Config Jenkins
> Please add a credentials first at jenkins, in order to clone the code. 
* Config pipeline `statement-loader` at `git@github.com:tw-bc-group/statement-loader.git` with jenkins file at `Jenkinsfile.groovy`.
* Config pipeline `reconciliation-system` at `git@github.com:tw-bc-group/reconciliation-system.git` with jenkins file at `Jenkinsfile.groovy`.
* Config pipeline `reconciliation-system-devops` at `git@github.com:tw-bc-group/reconciliation-system-devops.git` with jenkins file at `Jenkinsfile.groovy`.
* If both these three pipeline build successful, you can verify it as follow shows.

### Verify Reconciliation
1. Post: `http://{ci-ip-address}:8002/reconciliation`
    * Body: 
    ```
    {
     "start": 1576476000000, # in millisecond
     "end": 1576540800000 # in millisecond
    }
    ```
   * Response:
   ```
   {
       "id": "20191216-20191217-1581049017720"
   }
   ```
2. GET `http://{ci-ip-address}:8002/reconciliation/20191216-20191217-158104901772` # this is from the response above.

   If you can download a Excel file, That means your deployment is successful!
