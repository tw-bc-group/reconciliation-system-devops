variable "amis" {
  type = map
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