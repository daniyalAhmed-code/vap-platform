## WAF with F5 Group Rules
module "waf" {
  count  = var.create ? 1 : 0
  source = "./../core/waf"

  name  = var.name
  scope = var.is_regional ? "REGIONAL" : "CLOUDFRONT"

  managed_rules = [
    {
      excluded_rules : [],
      name : "API_Managed",
      vendor_name : "F5",
      override_action : "none",
      priority : 10
    },
    /* {
      excluded_rules : [],
      name : "Bots_Managed",
      vendor_name : "F5",
      override_action : "none",
      priority : 20
    },*/
    {
      excluded_rules : [],
      name : "OWASP_Managed",
      vendor_name : "F5",
      override_action : "none",
      priority : 30
    },
  ]
}
