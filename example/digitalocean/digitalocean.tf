terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = ">= 2.0"
    }
  }
  required_version = ">= 1.3.0"
}

provider "digitalocean" {
}

module "labels" {
  source = "../.." # adjust path

  name        = "payment-api"
  environment = "prod"
  repository  = "terraform-modules"
  attributes  = ["v1"]
  extra_tags = {
    Owner      = "primeOps-technologies"
    CostCenter = "Finance"
  }
}

locals {
  do_tags = [
    for k, v in module.labels.tags :
    "${k}:${v}"
  ]
}

# optionally create Tag objects in DO (not strictly required; DO auto-creates tags when applied)
resource "digitalocean_tag" "from_labels" {
  for_each = toset(local.do_tags)
  name     = each.key
}


resource "digitalocean_droplet" "web" {
  name   = "${module.labels.id}-vm"
  region = "nyc3"
  size   = "s-1vcpu-1gb"
  image  = "ubuntu-22-04-x64"
  tags   = local.do_tags
}