variable "sg_name" {
  type = string
}

variable "ingress_rules" {
  type = list(number)
}
variable "protocol" {
  type = string
}
variable "cidr_blocks" {
  type = list(string)
}