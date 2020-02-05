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
  type = string
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

variable "azs" {
  default = ["cn-northwest-1a", "cn-northwest-1b", "cn-northwest-1c"]
  type    = list
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
  type = number
  description = "Volume size for root block device."
}
