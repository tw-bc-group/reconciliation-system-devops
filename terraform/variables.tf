variable "access_key" {
  type = string
}

variable "secret_key" {
  type = string
}

variable "vpc_name" {
  type = string
}

variable "region" {
  description = "The region for EC2 instance."
  default = "us-west-1"
  type = string
}

variable "azs" {
  description = "Availability zones of the region."
  type    = list
  default = ["us-west-1a", "us-west-1c"]
}

variable "amis" {
  type = map
  description = "The region-ami map for AWS EC2."

  default = {
    "us-east-1" = "ami-b374d5a5"
    "us-west-1" = "ami-094f0176b0d009d9f"
    "us-east-2" = "ami-08cec7c429219e339"
    "cn-northwest-1" = "ami-09081e8e3d61f4b9e"
  }
}

variable "ec2_instance_key_name" {
  description = "The key to access ec2 instance."
  type = string
}

variable "security_group_name" {
  type = string
}

variable "prefix" {
  type = string
}

variable "jenkins_vpc_name" {
  default = "jenkins"
}

variable "env" {
  default = "dev"
}

variable "vpc_cidr" {
  default = "10.20.0.0/16"
}

//AWS VPC Variables
variable "aws_vpc_cidr_block" {
  description = "CIDR Block for VPC"
}
variable "aws_cidr_subnets_private" {
  description = "CIDR Blocks for private subnets in Availability Zones"
  type        = list
}
variable "aws_cidr_subnets_public" {
  description = "CIDR Blocks for public subnets in Availability Zones"
  type        = list
}

// CI Instance
variable "ci_instance_name" {
  description = "Instance name for CI server."
  type = string
}

variable "ci_instance_type" {
  default = "t2.small"
  type = string
}

variable "ci_instance_port" {
  type = number
  description = "Port for CI instance."
}

variable "volume_size" {
  default = 8
  type = number
  description = "Volume size for root block device. (Unit: GB)"
}
