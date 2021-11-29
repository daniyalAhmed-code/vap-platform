
resource "aws_security_group" "security_group" {
  vpc_id      = aws_vpc.main.id
  name        = "${var.RESOURCE_PREFIX}-security-group"
  description = "security group"
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    ipv6_cidr_blocks = [aws_vpc.main.ipv6_cidr_block]
  }
  ingress {
    from_port        = 443
    to_port          = 443
    protocol         = "TCP"
    cidr_blocks      = [aws_vpc.main.cidr_block]
    ipv6_cidr_blocks = [aws_vpc.main.ipv6_cidr_block]
    self             = true

  }
}
resource "aws_security_group" "allow_lambda_communication" {
  name        = "allow_lambda_communication"
  description = "Allow Lambda in VPC to Communicate With VPC Endpoints"
  vpc_id      = aws_vpc.main.id

  ingress {
    description      = "Allow Lambda in VPC to Communicate With VPC Endpoints"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = [aws_vpc.main.cidr_block]
    ipv6_cidr_blocks = [aws_vpc.main.ipv6_cidr_block]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}