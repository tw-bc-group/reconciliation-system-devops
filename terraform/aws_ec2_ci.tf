data "aws_availability_zones" "available" {}

module "key_pair" {
  source = "./modules/generate-key-pair"
  key_name = "jenkins"
}

module "vpc" {
  source                    = "git::https://github.com/tmknom/terraform-aws-vpc.git?ref=tags/1.0.0"
  cidr_block                = "${var.aws_vpc_cidr_block}"
  name                      = "session-manager"
  public_subnet_cidr_blocks = ["${cidrsubnet(var.aws_vpc_cidr_block, 8, 0)}", "${cidrsubnet(var.aws_vpc_cidr_block, 8, 1)}"]
  public_availability_zones = ["${data.aws_availability_zones.available.names}"]
}

module "security_group" {
  source = "./modules/security-group"
  group_name = "ci_security_group"
  vpc_id = "${module.vpc.vpc_id}"
}

module "ci_instance" {
  source = "./modules/ec2-instance"
  instance_name = "ci_instance"
  instance_type = "t2.micro"

  region = "${var.region}"

  key_name = "${module.key_pair.key_name}"
  private_key = "${module.key_pair.private_key}"

  security_group_id = "${module.security_group.id}"
  subnet_id = "${element(module.vpc.public_subnet_ids, 0)}"

  default_tags = {
    "Cost Center" = "${var.prefix}"
  }
}

resource "null_resource" "setup_jenkins" {
  depends_on = ["module.ci_instance"]

  provisioner "remote-exec" {
    connection {
      type = "ssh"
      user = "ubuntu"
      host = "${module.ci_instance.public_ip}"
      private_key = "${module.key_pair.private_key}"
    }

    inline = [
      "docker run --name jenkins -p 9000:8080 -p 50000:50000 -d jenkins"
    ]
  }
}