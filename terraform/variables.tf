variable "access_key" {
  type = string
}

variable "secret_key" {
  type = string
}

variable "region" {
  default = "cn-northwest-1"
}

variable "prefix" {
  default = "reconciliation"
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

variable "default_tags" {
  description = "Default tags for all resources"
  type        = map
}
