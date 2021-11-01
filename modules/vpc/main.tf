
data "aws_availability_zones" "azs" {}

resource "aws_vpc" "main" {
  cidr_block                       = var.CIDR_BLOCK
  instance_tenancy                 = "default"
  assign_generated_ipv6_cidr_block = true
  enable_dns_support               = true
  enable_dns_hostnames             = true
  tags = {
    Name = "${var.RESOURCE_PREFIX}-vpc"

  }

}

#INTERNET GATEWAY
resource "aws_egress_only_internet_gateway" "egress_only" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "${var.RESOURCE_PREFIX}-EGRESS-ONLY"
  }

}

