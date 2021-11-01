output "id" {
  value = aws_vpc.main.id
}

output "public_subnet" {
  value = aws_subnet.public.*.id
}

output "private_subnet" {
  value = [aws_subnet.private[0].id, aws_subnet.private[1].id, aws_subnet.private[2].id]
}

output "IPV6_CIDR_BLOCK" {
  value = aws_vpc.main.ipv6_cidr_block
}
output "CIDR_BLOCK" {
  value = aws_vpc.main.cidr_block
}
output "SG_ID" {
  value = aws_security_group.security_group.id
}
