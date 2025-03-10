resource "aws_network_acl" "public" {
  vpc_id = var.vpc_id

  dynamic "ingress" {
    for_each = local.aws_network_acl_public.ingress
    content {
      protocol   = ingress.value.protocol
      rule_no    = ingress.value.rule_no
      action     = ingress.value.action
      cidr_block = ingress.value.cidr_block
      from_port  = ingress.value.from_port
      to_port    = ingress.value.to_port

    }
  }

  dynamic "egress" {
    for_each = local.aws_network_acl_public.egress
    content {
      protocol   = egress.value.protocol
      rule_no    = egress.value.rule_no
      action     = egress.value.action
      cidr_block = egress.value.cidr_block
      from_port  = egress.value.from_port
      to_port    = egress.value.to_port
    }
  }

  tags = {
    Name = "${var.environment}-nacl-public"
  }
}

resource "aws_network_acl" "private" {
  vpc_id = var.vpc_id

  dynamic "ingress" {
    for_each = local.aws_network_acl_private.ingress
    content {
      protocol   = ingress.value.protocol
      rule_no    = ingress.value.rule_no
      action     = ingress.value.action
      cidr_block = ingress.value.cidr_block
      from_port  = ingress.value.from_port
      to_port    = ingress.value.to_port
    }
  }

  dynamic "egress" {
    for_each = local.aws_network_acl_public.egress
    content {
      protocol   = egress.value.protocol
      rule_no    = egress.value.rule_no
      action     = egress.value.action
      cidr_block = egress.value.cidr_block
      from_port  = egress.value.from_port
      to_port    = egress.value.to_port
    }
  }

  tags = {
    Name = "${var.environment}-nacl-private"
  }
}

resource "aws_network_acl_association" "public" {
  for_each       = { for idx, v in var.public_subnet_ids : idx => v }
  network_acl_id = aws_network_acl.public.id
  subnet_id      = each.value
}
resource "aws_network_acl_association" "private" {
  for_each       = { for idx, v in var.private_subnet_ids : idx => v }
  network_acl_id = aws_network_acl.private.id
  subnet_id      = each.value
}
