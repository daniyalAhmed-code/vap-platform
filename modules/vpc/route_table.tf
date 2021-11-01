
# ROUTE TABLE
resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "${var.RESOURCE_PREFIX}-INTERNAL-ROUTE-TABLE"
  }

}

resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.main.id
  route {
    ipv6_cidr_block        = "::/64"
    egress_only_gateway_id = aws_egress_only_internet_gateway.egress_only.id
  }

  tags = {
    Name = "${var.RESOURCE_PREFIX}-EXTERNAL-ROUTE-TABLE"
  }

}

# ROUTE TABLE ASSOCIATION



resource "aws_route_table_association" "private_route_table_association" {
  count          = var.PRIVATE_SUBNETS
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private_route_table.id
  depends_on = [
    aws_subnet.private,
    aws_route_table.private_route_table,
  ]
}


resource "aws_route_table_association" "public_route_table_association" {
  count          = var.PUBLIC_SUBNETS
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public_route_table.id
  depends_on = [
    aws_subnet.public,
    aws_route_table.public_route_table,
  ]
}
