resource "aws_lb" "network_load_balancer" {
  name               = "${var.RESOURCE_PREFIX}-nlb"
  internal           = true
  load_balancer_type = "network"
  subnets            = var.PRIVATE_SUBNET_MAPPING

  enable_deletion_protection = false

}

resource "aws_lb_target_group" "alb_tg" {
  name        = "${var.RESOURCE_PREFIX}-alb-tg"
  port        = 443
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = var.VPC_ID
}
resource "aws_lb_target_group" "nlb_tg" {
  name        = "${var.RESOURCE_PREFIX}-nlb-tg"
  port        = 443
  protocol    = "TCP"
  target_type = "ip"
  vpc_id      = var.VPC_ID
}



resource "aws_lb_listener" "alb_listener" {
  load_balancer_arn = aws_lb.application_load_balancer.arn
  port              = "443"
  protocol          = "HTTP"


  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb_tg.arn
  }
}

resource "aws_lb_listener" "nlb_listener" {
  load_balancer_arn = aws_lb.network_load_balancer.arn
  port              = "443"
  protocol          = "TCP"


  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.nlb_tg.arn
  }
}

resource "aws_lb" "application_load_balancer" {
  name                       = "${var.RESOURCE_PREFIX}-alb"
  internal                   = true
  load_balancer_type         = "application"
  subnets                    = var.PRIVATE_SUBNET_MAPPING
  enable_deletion_protection = false
  security_groups            = [var.SG_ID]

}


resource "aws_api_gateway_vpc_link" "vpc_link" {
  name        = "${var.RESOURCE_PREFIX}-vpc-link"
  description = "vpc_link"
  target_arns = [aws_lb.network_load_balancer.arn]
}