variable "my_ip" {
  default = "103.172.203.29/32"
}

variable "cidr_block" {
  type    = list(string)
  default = ["0.0.0.0/0"]
}


