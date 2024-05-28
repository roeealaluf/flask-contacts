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


provider "docker" {
  host = "unix:///var/run/docker.sock"
}

resource "docker_image" "contacsweb_image" {
  name         = "your-web-image:latest"
  keep_locally = false
}

resource "docker_container" "contacsweb_container" {
  name  = "contacsweb"
  image = docker_image.contacsweb_image.latest

  ports {
    internal = 80
    external = 8080
  }

  env = [
    "DB_HOST=contacsdb",
    "DB_PORT=5432",
    "DB_USER=youruser",
    "DB_PASSWORD=yourpassword"
  ]

  depends_on = [docker_container.contacsdb_container]
}

resource "docker_image" "contacsdb_image" {
  name         = "contactsweb:latest"
  keep_locally = false
}

resource "docker_container" "contacsdb_container" {
  name  = "contacsdb"
  image = docker_image.contacsdb_image.latest

  ports {
    internal = 5432
    external = 5432
  }

  env = [
    "POSTGRES_USER=youruser",
    "POSTGRES_PASSWORD=yourpassword",
    "POSTGRES_DB=yourdatabase"
  ]
}

output "contacsweb_container_id" {
  value = docker_container.contacsweb_container.id
}

output "contacsdb_container_id" {
  value = docker_container.contacsdb_container.id
}

output "contacsweb_container_ip" {
  value = docker_container.contacsweb_container.ip_address
}

output "contacsdb_container_ip" {
  value = docker_container.contacsdb_container.ip_address
}
