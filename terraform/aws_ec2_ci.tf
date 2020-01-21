module "key_pair" {
  source = "./modules/generate-key-pair"
  key_name = "reconciliation_ci_key"
}

module "vpc" {
  source = "./modules/vpc"
  cidr_block = var.aws_vpc_cidr_block
  name = "reconciliation_vpc"
  public_subnet_cidr_blocks = [
    cidrsubnet(var.aws_vpc_cidr_block, 8, 0),
    cidrsubnet(var.aws_vpc_cidr_block, 8, 1)]
  public_availability_zones = var.azs
}

module "security_group" {
  source = "./modules/security-group"
  group_name = "reconciliation_ci_security_group"
  vpc_id = module.vpc.vpc_id
}

module "ci_instance" {
  source = "./modules/ec2-instance"
  instance_name = "new_ci_instance"
  instance_type = "t2.small"

  region = var.region

  key_name = module.key_pair.key_name
  private_key = module.key_pair.private_key

  security_group_id = module.security_group.id
  subnet_id = element(module.vpc.public_subnet_ids, 0)

  default_tags = {
    "Cost Center" = var.prefix
  }
}

resource "null_resource" "setup_jenkins" {
  depends_on = [
    module.ci_instance]

  provisioner "remote-exec" {
    connection {
      type = "ssh"
      user = "ubuntu"
      host = module.ci_instance.public_ip
      private_key = module.key_pair.private_key
    }

    inline = [
      "sudo apt install default-jre -y",
      "wget -q -O - https://pkg.jenkins.io/debian/jenkins.io.key | sudo apt-key add -",
      "sudo sh -c 'echo deb https://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'",
      "sudo apt-get update",
      "sudo apt-get install jenkins -y",
      "sudo sed -i 's/HTTP_PORT=8080/HTTP_PORT=9000/g' /etc/default/jenkins",
      "sudo systemctl restart jenkins.service",
      "docker run -d -p 5000:5000 --name registry registry:2"
    ]
  }
}