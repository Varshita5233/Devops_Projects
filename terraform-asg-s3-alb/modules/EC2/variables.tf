variable "ami" {}
variable "instance_type" {}
variable "public_subnets" {
    type = list(string)
}
variable "private_subnets" {
    type = list(string)
}

variable "public_security_groups" {
  type = list(string)
}

variable "private_security_groups" {
  type = list(string)
}

variable "key_name" {
  type = string
}