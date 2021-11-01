
resource "aws_vpc_endpoint" "s3" {
  vpc_id            = aws_vpc.main.id
  service_name      = "com.amazonaws.${var.REGION}.s3"
  vpc_endpoint_type = "Gateway"
  #   security_group_ids = [aws_security_group.security_group.id]
}
resource "aws_vpc_endpoint" "secretsmanager" {
  vpc_id              = aws_vpc.main.id
  service_name        = "com.amazonaws.${var.REGION}.secretsmanager"
  vpc_endpoint_type   = "Interface"
  security_group_ids  = [aws_security_group.security_group.id]
  private_dns_enabled = true
}
resource "aws_vpc_endpoint" "ecr" {
  vpc_id              = aws_vpc.main.id
  service_name        = "com.amazonaws.${var.REGION}.ecr.api"
  vpc_endpoint_type   = "Interface"
  security_group_ids  = [aws_security_group.security_group.id]
  private_dns_enabled = true
}
resource "aws_vpc_endpoint" "codcommit" {
  vpc_id              = aws_vpc.main.id
  service_name        = "com.amazonaws.${var.REGION}.codecommit"
  vpc_endpoint_type   = "Interface"
  security_group_ids  = [aws_security_group.security_group.id]
  private_dns_enabled = true
}
resource "aws_vpc_endpoint" "git_codcommit" {
  vpc_id              = aws_vpc.main.id
  service_name        = "com.amazonaws.${var.REGION}.git-codecommit"
  vpc_endpoint_type   = "Interface"
  security_group_ids  = [aws_security_group.security_group.id]
  private_dns_enabled = true
}
resource "aws_vpc_endpoint" "dynamodb" {
  vpc_id            = aws_vpc.main.id
  service_name      = "com.amazonaws.${var.REGION}.dynamodb"
  vpc_endpoint_type = "Gateway"
  #   security_group_ids = [aws_security_group.security_group.id]
}
resource "aws_vpc_endpoint" "sqs" {
  vpc_id              = aws_vpc.main.id
  service_name        = "com.amazonaws.${var.REGION}.sqs"
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = true
  security_group_ids  = [aws_security_group.security_group.id]
}
resource "aws_vpc_endpoint" "sns" {
  vpc_id              = aws_vpc.main.id
  service_name        = "com.amazonaws.${var.REGION}.sns"
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = true
  security_group_ids  = [aws_security_group.security_group.id]
}

resource "aws_vpc_endpoint" "cloudwatch_logs" {
  vpc_id              = aws_vpc.main.id
  service_name        = "com.amazonaws.${var.REGION}.logs"
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = true
  security_group_ids  = [aws_security_group.security_group.id]
}


## ENDPOINT ASSOCIATION

resource "aws_vpc_endpoint_route_table_association" "s3_endpoint_assoiciation" {
  route_table_id  = aws_route_table.private_route_table.id
  vpc_endpoint_id = aws_vpc_endpoint.s3.id
}

resource "aws_vpc_endpoint_subnet_association" "secretsmanager_endpoint_association" {
  count = length(data.aws_availability_zones.azs.names)

  vpc_endpoint_id = aws_vpc_endpoint.secretsmanager.id
  subnet_id       = aws_subnet.private[count.index].id
}

resource "aws_vpc_endpoint_subnet_association" "ecr_endpoint_association" {
  count           = length(data.aws_availability_zones.azs.names)
  subnet_id       = aws_subnet.private[count.index].id
  vpc_endpoint_id = aws_vpc_endpoint.ecr.id
}

resource "aws_vpc_endpoint_subnet_association" "codcommit_endpoint_association" {
  count           = length(data.aws_availability_zones.azs.names)
  subnet_id       = aws_subnet.private[count.index].id
  vpc_endpoint_id = aws_vpc_endpoint.codcommit.id
}

resource "aws_vpc_endpoint_subnet_association" "git_codcommit_endpoint_association" {
  count           = length(data.aws_availability_zones.azs.names)
  subnet_id       = aws_subnet.private[count.index].id
  vpc_endpoint_id = aws_vpc_endpoint.git_codcommit.id
}

resource "aws_vpc_endpoint_route_table_association" "dynamodb_endpoint_association" {
  route_table_id  = aws_route_table.private_route_table.id
  vpc_endpoint_id = aws_vpc_endpoint.dynamodb.id
}

resource "aws_vpc_endpoint_subnet_association" "sqs_endpoint_association" {
  count           = length(data.aws_availability_zones.azs.names)
  subnet_id       = aws_subnet.private[count.index].id
  vpc_endpoint_id = aws_vpc_endpoint.sqs.id
}
resource "aws_vpc_endpoint_subnet_association" "sns_endpoint_association" {

  count           = length(data.aws_availability_zones.azs.names)
  subnet_id       = aws_subnet.private[count.index].id
  vpc_endpoint_id = aws_vpc_endpoint.sns.id
}
resource "aws_vpc_endpoint_subnet_association" "cloudwatch_logs_endpoint_association" {
  count           = length(data.aws_availability_zones.azs.names)
  subnet_id       = aws_subnet.private[count.index].id
  vpc_endpoint_id = aws_vpc_endpoint.cloudwatch_logs.id
}