variable "cidr_block" {}
variable "vpc_name"{}
variable "public_subnets" {
  type = list(string)
}
variable "private_subnets" {
  type = list(string)
}
variable "az" {
  type = list(string)
}