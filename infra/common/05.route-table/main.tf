# Public route table
resource "aws_route_table" "public_route_table" {
  vpc_id = var.vpc_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = var.igw_id
  }

  tags = {
    Name = "${var.environment}-public-rt"
  }
}

resource "aws_route_table_association" "public_associations" {
  for_each       = tomap({ for idx, subnet_id in var.subnet_ids.public : idx => subnet_id })
  subnet_id      = each.value
  route_table_id = aws_route_table.public_route_table.id
}

# Private route table
resource "aws_route_table" "private_route_table" {
  vpc_id = var.vpc_id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = var.nat_id
  }

  tags = {
    Name = "${var.environment}-private-rt"
  }
}

resource "aws_route_table_association" "private_associations" {
  count          = length(var.subnet_ids.private)
  subnet_id      = var.subnet_ids.private[count.index]
  route_table_id = aws_route_table.private_route_table.id
}
