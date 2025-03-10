locals {
  aws_network_acl_public = {
    ingress = [
      { protocol = "-1", rule_no = 100, action = "allow", cidr_block = "0.0.0.0/0", from_port = 0, to_port = 0 },
    ]
    egress = [{ protocol = "-1", rule_no = 100, action = "allow", cidr_block = "0.0.0.0/0", from_port = 0, to_port = 0 }]
  }

  aws_network_acl_private = {
    ingress = [
      { protocol = "-1", rule_no = 100, action = "allow", cidr_block = "0.0.0.0/0", from_port = 0, to_port = 0 },
    ]
    egress = [{ protocol = "-1", rule_no = 100, action = "allow", cidr_block = "0.0.0.0/0", from_port = 0, to_port = 0 }]
  }
}
