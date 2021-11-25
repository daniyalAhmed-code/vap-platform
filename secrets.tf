#################
#### Secrets ####
#################
module "vdp_pt_secret" {
  source                  = "./modules/secrets"
  name                    = "/dani/sitetracker/Portugal/Vodafone"
  description             = "Secret with Site Tracker Credentials To VDF PT Mno in Portugal"
  kms_key_id              = module.kms.key_id
  recovery_window_in_days = var.secrets_recovery_window_in_days
  value = jsonencode({
    username : "changeme",
    password : "changeme",
    security_token : "changeme",
    client_id : "changeme",
    client_secret : "changeme",
    domain : "changeme"
  })
}
