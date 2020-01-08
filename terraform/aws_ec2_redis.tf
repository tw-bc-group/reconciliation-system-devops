module "redis_key_pair" {
  source = "./modules/generate-key-pair"
  key_name = "redis"
}

module "redis_security_group" {
  source = "./modules/security-group"
  group_name = "redis_security_group"
  vpc_id = module.vpc.vpc_id
}

module "redis_instance" {
  source = "./modules/ec2-instance"
  instance_name = "redis_instance"
  instance_type = "t2.micro"

  region = var.region

  key_name = module.key_pair.key_name
  private_key = module.key_pair.private_key

  security_group_id = module.security_group.id
  subnet_id = element(module.vpc.public_subnet_ids, 0)

  default_tags = {
    "Cost Center" = var.prefix
  }
}

resource "null_resource" "setup_redis" {
  depends_on = [module.redis_instance]

  provisioner "remote-exec" {
    connection {
      type = "ssh"
      user = "ubuntu"
      host = module.redis_instance.public_ip
      private_key = module.key_pair.private_key
    }

    script = "terraformProvisionRedisUsingDocker.sh"

  }
}
