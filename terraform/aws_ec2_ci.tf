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

resource "aws_instance" "ci" {
  ami             = "${lookup(var.amis, var.region)}"
  instance_type   = "t2.micro"
  key_name        = "${module.key_pair.key_name}"

  vpc_security_group_ids = ["${module.security_group.id}"]
  subnet_id = "${element(module.vpc.public_subnet_ids, 0)}"

  connection {
      type = "ssh"
      user = "ubuntu"
      private_key = "${module.key_pair.private_key}"
  }

  provisioner "remote-exec" {
    inline = [
      "/bin/bash -c 'sudo apt-get update'",
      "/bin/bash -c 'sudo apt -y install docker.io'",

      "/bin/bash -c 'sudo service docker start'",
      "/bin/bash -c 'sudo groupadd docker'",
      "/bin/bash -c 'sudo usermod -a -G docker ubuntu'",
      "/bin/bash -c 'sudo systemctl restart docker'",
      "/bin/bash -c 'sudo chmod a+rw /var/run/docker.sock'",
    ]
  }

  tags = {
    name          = "${var.prefix}-jenkins"
    "Cost Center" = "${var.prefix}"
  }
}

resource "null_resource" "setup_jenkins" {
  depends_on = ["aws_instance.ci"]

  provisioner "remote-exec" {
    connection {
      type = "ssh"
      user = "ubuntu"
      host = "${aws_instance.ci.public_ip}"
      private_key = "${module.key_pair.private_key}"
    }

    inline = [
      "docker run --name jenkins -p 9000:8080 -p 50000:50000 -d jenkins"
    ]
  }
}