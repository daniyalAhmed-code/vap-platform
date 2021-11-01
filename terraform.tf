terraform { 
  backend "s3" { 
    bucket         = "dani-dev-terraform-remote-state-centralised" 
    dynamodb_table = "	dani-terraform-locks-centralised" 
    region         = "us-east-1" 
    key            = "vap-api-platform/{{ENV}}/terraform.tfstate" 
  }
}