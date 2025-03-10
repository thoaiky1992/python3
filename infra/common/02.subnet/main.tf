resource "aws_subnet" "subnets" {
  for_each                = { for subnet in concat(local.public_subnets, local.private_subnets) : subnet.name => subnet }
  vpc_id                  = var.vpc_id
  cidr_block              = each.value.cidr_block
  availability_zone       = each.value.availability_zone
  map_public_ip_on_launch = each.value.map_public_ip_on_launch
  tags = {
    Name = "${var.environment}-${each.value.name}"
  }
}
