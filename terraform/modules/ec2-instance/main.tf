resource "aws_instance" "ec2-instance" {
  ami = lookup(var.amis, var.region)
  instance_type = var.instance_type
  key_name = var.key_name

  vpc_security_group_ids = [var.security_group_id]
  subnet_id = var.subnet_id

  root_block_device {
    volume_size       = var.volume_size
  }

  connection {
    type = "ssh"
    user = "ubuntu"
    private_key = var.private_key
    host = self.public_ip
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
      "/bin/bash -c 'sudo curl -L \"https://github.com/docker/compose/releases/download/1.25.3/docker-compose-$(uname -s)-$(uname -m)\" -o /usr/local/bin/docker-compose'",
      "/bin/bash -c 'sudo chmod +x /usr/local/bin/docker-compose'",
    ]
  }

  tags = merge(var.default_tags, map("Name", var.instance_name))
}
