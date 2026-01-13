resource "aws_security_group" "Monitoring-SG" {
    name = var.sg_name

    dynamic "ingress" {
      for_each = var.ingress_rules
      content {
        from_port = ingress.value
        to_port = ingress.value
        protocol = var.protocol
        cidr_blocks = var.cidr_blocks
      }
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = var.cidr_blocks
    }


}