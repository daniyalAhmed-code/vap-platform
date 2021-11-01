
# SUBNETS

resource "aws_subnet" "private" {
  count             = var.PRIVATE_SUBNETS
  vpc_id            = aws_vpc.main.id
  availability_zone = data.aws_availability_zones.azs.names[count.index % length(data.aws_availability_zones.azs.names)]
  cidr_block        = cidrsubnet(var.CIDR_BLOCK, 4, count.index + 3)
  ipv6_cidr_block   = cidrsubnet(aws_vpc.main.ipv6_cidr_block, 8, count.index + 3)
  tags = {
    Name = "${var.RESOURCE_PREFIX}-INTERNAL-SUBNET"
  }
}


resource "aws_subnet" "public" {
  count             = var.PUBLIC_SUBNETS
  vpc_id            = aws_vpc.main.id
  availability_zone = data.aws_availability_zones.azs.names[count.index % length(data.aws_availability_zones.azs.names)]
  cidr_block        = cidrsubnet(var.CIDR_BLOCK, 4, count.index)
  ipv6_cidr_block   = cidrsubnet(aws_vpc.main.ipv6_cidr_block, 8, count.index)
  tags = {
    Name = "${var.RESOURCE_PREFIX}-EXTERNAL-SUBNET"
  }
}
