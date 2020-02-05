module "key_pair" {
  source = "./modules/generate-key-pair"
  key_name = var.ec2_instance_key_name
}

module "vpc" {
  source = "./modules/vpc"
  cidr_block = var.aws_vpc_cidr_block
  name = var.vpc_name
  public_subnet_cidr_blocks = [
    cidrsubnet(var.aws_vpc_cidr_block, 8, 0),
    cidrsubnet(var.aws_vpc_cidr_block, 8, 1)]
  public_availability_zones = var.azs
}

module "security_group" {
  source = "./modules/security-group"
  group_name = var.security_group_name
  vpc_id = module.vpc.vpc_id
  ci_instance_port = var.ci_instance_port
}

module "ci_instance" {
  source = "./modules/ec2-instance"
  instance_name = var.ci_instance_name
  instance_type = var.ci_instance_type

  region = var.region

  key_name = module.key_pair.key_name
  private_key = module.key_pair.private_key

  security_group_id = module.security_group.id
  subnet_id = element(module.vpc.public_subnet_ids, 0)

  default_tags = {
    "Cost Center" = var.prefix
  }
}

resource "null_resource" "copy_install_jenkins_shell_script" {
  depends_on = [
    module.ci_instance]

  provisioner "file" {
    source = "installJenkins.sh"
    destination = "/var/tmp/installJenkins.sh"

    connection {
      type = "ssh"
      user = "ubuntu"
      host = module.ci_instance.public_ip
      private_key = module.key_pair.private_key
    }
  }
}

resource "null_resource" "install_Jenkins" {
  depends_on = [
    null_resource.copy_install_jenkins_shell_script]

  provisioner "remote-exec" {
    connection {
      type = "ssh"
      user = "ubuntu"
      host = module.ci_instance.public_ip
      private_key = module.key_pair.private_key
    }

    inline = [
      "chmod +x /var/tmp/installJenkins.sh",
      "/var/tmp/installJenkins.sh ${tostring(var.ci_instance_port)}"
    ]
  }
}

output "ci_instance_ip_addr" {
  value = module.ci_instance.public_ip
  description = "The public IP address of CI server instance. (To access the page, you should addon the port you specify.)"
}