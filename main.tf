# variables
locals {
  envs = {for tuple in regexall("(.*)=(.*)", file(".env")) : tuple[0] => sensitive(tuple[1]) }
}


terraform {
  required_providers {
    vultr = {
      source = "vultr/vultr"
      version = "2.19.0"
    }
  }
}

provider "vultr" {
  api_key = local.envs["api_key"]
  rate_limit = 100
  retry_limit = 3
}
 output "api_key" {
   value = local.envs["api_key"]
   sensitive = true
 }
resource "vultr_instance" "jenkins" {
  plan = "vc2-1c-2gb"
  region = "tlv"
  os_id = 1743
   hostname = "ubuntu-jenkins"
  label ="ubuntu-jenkins"
  tags = ["ubuntu","jenkins"] 
  backups = "disabled"
}