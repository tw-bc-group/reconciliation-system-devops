variable "amis" {
  type = map

  default = {
    "us-east-1" = "ami-b374d5a5"
    "us-west-1" = "ami-094f0176b0d009d9f"
    "us-east-2" = "ami-08cec7c429219e339"
    "cn-northwest-1" = "ami-09081e8e3d61f4b9e"
  }
}

variable "region" {
  type = string
}

variable "volume_size" {
  default = 8
  type = number
  description = "Volume size for root block device. (Unit: GB)"
}

variable "key_name" {
  description = "The name of the key pair."
  type = string
}

variable "private_key" {
  description = "private key of key pair."
  type = string
}

variable "security_group_id" {
  description = "The ID of security group."
  type = string
}

variable "subnet_id" {
  description = "The id of subnet of ec2 instance."
  type = string
}

variable "default_tags" {
  description = "Default tags for ec2 instace"
  type = map
}

variable "instance_name" {
  default = "Name of the instance."
  type = string
}

variable "instance_type" {
  default = "Type of instance."
  type = string
}