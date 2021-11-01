output "target_group_arn" {
  value = aws_lb_target_group.nlb_tg.arn
}

output "dns_name" {
  value = aws_lb.application_load_balancer.dns_name
}
